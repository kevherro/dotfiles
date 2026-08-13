#!/usr/bin/env python3
"""Run mechanical integrity checks on a Markdown technical specification.

This linter does not judge semantic design quality. It detects unresolved
markers, invalid readiness status, malformed markers, empty sections, and broken
local links. Exit 0 means no warning or error, exit 1 means a warning or error
was reported, and exit 2 means the file or invocation could not be processed.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from urllib.parse import unquote

ALLOWED_STATUSES = {
    "implementation_ready",
    "needs_evidence",
    "needs_technical_decision",
    "needs_authoritative_clarification",
    "constraint_conflict",
    "direction_not_aligned",
}

STATUS_PATTERNS = (
    re.compile(
        r"^\s*#{0,6}\s*(?:\*\*)?status(?:\*\*)?\s*:\s*`?"
        r"([a-z_]+)`?(?:\s|$)",
        re.IGNORECASE,
    ),
    re.compile(
        r"^\s*[-*]?\s*(?:\*\*)?status(?:\*\*)?\s*:\s*`?"
        r"([a-z_]+)`?(?:\s|$)",
        re.IGNORECASE,
    ),
    re.compile(
        r"^\s*\|\s*(?:\*\*)?status(?:\*\*)?\s*\|\s*`?"
        r"([a-z_]+)`?\s*\|",
        re.IGNORECASE,
    ),
)

MARKER_PATTERN = re.compile(r"\[(OPEN|NEEDS\s+EVIDENCE|ASSUMPTION)\s*:", re.IGNORECASE)
PLACEHOLDER_PATTERN = re.compile(
    r"\b(TODO|TBD|FIXME|TK)\b|\?\?\?|\[\s*insert\b|<\s*placeholder\s*>",
    re.IGNORECASE,
)
LINK_PATTERN = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
HEADING_PATTERN = re.compile(r"^(#{1,6})\s+(.+?)\s*$")


@dataclass(frozen=True)
class Finding:
    severity: str
    code: str
    line: int
    message: str


def visible_lines(text: str) -> list[str]:
    """Blank fenced code while preserving line numbers."""

    result: list[str] = []
    fence: str | None = None
    for line in text.splitlines():
        stripped = line.lstrip()
        marker = None
        if stripped.startswith("```"):
            marker = "```"
        elif stripped.startswith("~~~"):
            marker = "~~~"

        if marker is not None:
            if fence is None:
                fence = marker
            elif fence == marker:
                fence = None
            result.append("")
            continue

        result.append("" if fence else line)
    return result


def detect_status(lines: list[str]) -> tuple[str | None, list[Finding]]:
    matches: list[tuple[int, str]] = []
    for number, line in enumerate(lines[:120], start=1):
        normalized = line.replace("**", "")
        for pattern in STATUS_PATTERNS:
            match = pattern.search(normalized)
            if match:
                matches.append((number, match.group(1).lower()))
                break

    findings: list[Finding] = []
    if not matches:
        findings.append(
            Finding(
                "error",
                "missing-status",
                1,
                "Add one Status field near the start of the document.",
            )
        )
        return None, findings

    distinct = sorted({status for _, status in matches})
    if len(matches) > 1:
        findings.append(
            Finding(
                "error",
                "multiple-status",
                matches[1][0],
                "Keep exactly one Status field; found: " + ", ".join(distinct),
            )
        )

    status = matches[0][1]
    if status not in ALLOWED_STATUSES:
        findings.append(
            Finding(
                "error",
                "invalid-status",
                matches[0][0],
                f"Status '{status}' is not one of: "
                + ", ".join(sorted(ALLOWED_STATUSES)),
            )
        )
    return status, findings


def check_markers(lines: list[str], status: str | None) -> list[Finding]:
    findings: list[Finding] = []
    visible_text = "\n".join(lines)
    for match in MARKER_PATTERN.finditer(visible_text):
        number = visible_text.count("\n", 0, match.start()) + 1
        closing = visible_text.find("]", match.end())
        next_marker = visible_text.find("[", match.end())
        if closing == -1 or (next_marker != -1 and next_marker < closing):
            findings.append(
                Finding(
                    "error",
                    "unclosed-marker",
                    number,
                    f"Close the [{match.group(1).upper()}: ...] marker.",
                )
            )
        severity = "error" if status == "implementation_ready" else "info"
        findings.append(
            Finding(
                severity,
                "unresolved-marker",
                number,
                f"Resolve or account for {match.group(1).upper()} before readiness.",
            )
        )

    for number, line in enumerate(lines, start=1):
        if PLACEHOLDER_PATTERN.search(line):
            severity = "error" if status == "implementation_ready" else "warning"
            findings.append(
                Finding(
                    severity,
                    "placeholder",
                    number,
                    "Replace the unresolved placeholder with evidence, an owned gap, or final text.",
                )
            )
    return findings


def check_empty_sections(lines: list[str]) -> list[Finding]:
    findings: list[Finding] = []
    headings: list[tuple[int, int, str]] = []
    for number, line in enumerate(lines, start=1):
        match = HEADING_PATTERN.match(line)
        if match:
            headings.append((number, len(match.group(1)), match.group(2)))

    for index, (number, level, title) in enumerate(headings):
        end = len(lines) + 1
        for later_number, later_level, _ in headings[index + 1 :]:
            if later_level <= level:
                end = later_number
                break
        body = lines[number : end - 1]
        has_text = any(
            candidate.strip()
            and not HEADING_PATTERN.match(candidate)
            and not candidate.strip().startswith("<!--")
            for candidate in body
        )
        has_child = any(
            level < later_level and later_number < end
            for later_number, later_level, _ in headings[index + 1 :]
        )
        if not has_text and not has_child:
            findings.append(
                Finding(
                    "warning",
                    "empty-section",
                    number,
                    f"Section '{title}' has no content; remove it or explain its inapplicability.",
                )
            )
    return findings


def check_local_links(lines: list[str], spec_path: Path, root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for number, line in enumerate(lines, start=1):
        for match in LINK_PATTERN.finditer(line):
            raw_target = match.group(1).strip()
            if raw_target.startswith("<") and ">" in raw_target:
                target = raw_target[1 : raw_target.index(">")]
            else:
                target = raw_target.split(maxsplit=1)[0]
            if not target or target.startswith(("#", "http://", "https://", "mailto:")):
                continue
            target = unquote(target.split("#", 1)[0])
            if not target:
                continue
            candidate = Path(target)
            if not candidate.is_absolute():
                candidate = spec_path.parent / candidate
                if not candidate.exists():
                    alternate = root / target
                    if alternate.exists():
                        continue
            if not candidate.exists():
                findings.append(
                    Finding(
                        "warning",
                        "broken-local-link",
                        number,
                        f"Local link target does not exist: {target}",
                    )
                )
    return findings


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Check mechanical integrity of a Markdown technical specification."
    )
    parser.add_argument("spec", type=Path, help="Markdown specification to lint")
    parser.add_argument(
        "--root",
        type=Path,
        help="Optional project root used as a second base for local links",
    )
    parser.add_argument(
        "--json", action="store_true", help="Emit a machine-readable JSON report"
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    spec_path = args.spec.resolve()
    root = (args.root or spec_path.parent).resolve()

    try:
        text = spec_path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as error:
        print(f"error: cannot read {spec_path}: {error}", file=sys.stderr)
        return 2

    lines = visible_lines(text)
    status, findings = detect_status(lines)
    findings.extend(check_markers(lines, status))
    findings.extend(check_empty_sections(lines))
    findings.extend(check_local_links(lines, spec_path, root))

    severity_order = {"error": 0, "warning": 1, "info": 2}
    findings.sort(
        key=lambda item: (item.line, severity_order[item.severity], item.code)
    )

    if args.json:
        print(
            json.dumps(
                {
                    "path": str(spec_path),
                    "status": status,
                    "findings": [asdict(item) for item in findings],
                },
                indent=2,
                sort_keys=True,
            )
        )
    elif findings:
        for item in findings:
            print(
                f"{spec_path}:{item.line}: {item.severity}: {item.code}: {item.message}"
            )
    else:
        print(f"{spec_path}: clean ({status})")

    has_actionable_finding = any(
        item.severity in {"error", "warning"} for item in findings
    )
    return 1 if has_actionable_finding else 0


if __name__ == "__main__":
    raise SystemExit(main())
