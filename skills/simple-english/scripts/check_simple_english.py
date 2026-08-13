#!/usr/bin/env python3
"""Advisory mechanical checks for clear technical English.

This script reports countable or searchable patterns. It does not assess factual
fidelity, grammatical correctness, readability, or ASD-STE100 compliance.

Examples:
  python3 check_simple_english.py --kind procedure guide.md
  python3 check_simple_english.py --kind explanation --format json article.md
  printf '%s\n' 'If the cache is empty, refresh it.' | python3 check_simple_english.py -
  python3 check_simple_english.py --self-test
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path


LIMITS = {"procedure": 20, "explanation": 25}

CONTRACTION_RE = re.compile(
    r"\b(?:[A-Za-z]+n't|(?:I|you|we|they|he|she|it|that|there|what|who)'(?:m|re|ve|ll|d|s))\b",
    re.IGNORECASE,
)
EMPTY_FILLER_RE = re.compile(
    r"\b(?:simply|seamlessly|effortlessly|obviously|basically|"
    r"it is worth noting that|it should be noted that|in order to)\b",
    re.IGNORECASE,
)
INFLATED_RE = re.compile(
    r"\b(?:leverage|utilize|facilitate|delve|robust|powerful|comprehensive|"
    r"state-of-the-art|best-in-class|game-changing)\b",
    re.IGNORECASE,
)
AMBIGUOUS_MODAL_RE = re.compile(r"\b(?:may|might|could|should|would)\b", re.IGNORECASE)
DANGLING_ING_RE = re.compile(
    r",\s+(?:allowing|causing|creating|enabling|ensuring|helping|making|providing|resulting)\b",
    re.IGNORECASE,
)
TRAILING_CONDITION_RE = re.compile(r"\b(?:if|when|unless)\b", re.IGNORECASE)
IMPERATIVE_HINT_RE = re.compile(
    r"^(?:do not\s+|don't\s+)?(?:add|ask|avoid|back up|check|choose|clear|click|close|"
    r"configure|connect|copy|create|delete|disable|download|edit|enable|enter|export|"
    r"get|give|install|keep|make|move|open|press|read|remove|restart|restore|run|save|"
    r"select|send|set|start|stop|update|upload|use|verify|wait|write)\b",
    re.IGNORECASE,
)
TERM_GROUPS = {
    "configuration terms": ("config", "configuration", "settings", "options"),
    "execution terms": ("run", "execute", "invoke", "launch"),
    "inspection terms": ("check", "verify", "confirm", "validate"),
}


@dataclass(frozen=True)
class Finding:
    code: str
    severity: str
    line: int
    excerpt: str
    message: str


def mask_markdown(text: str) -> str:
    """Mask protected Markdown while retaining newlines and inline token weight."""

    def keep_lines(match: re.Match[str]) -> str:
        return "\n" * match.group(0).count("\n")

    text = re.sub(r"```.*?```", keep_lines, text, flags=re.DOTALL)
    text = re.sub(r"`[^`\n]+`", " CODE ", text)
    text = re.sub(r"https?://[^\s)>]+", " URL ", text)
    text = re.sub(r"^\s*\|.*\|\s*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\s{0,3}#{1,6}\s+.*$", "", text, flags=re.MULTILINE)
    return text


def line_number(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def compact_excerpt(value: str, limit: int = 96) -> str:
    value = re.sub(r"\s+", " ", value).strip()
    return value if len(value) <= limit else value[: limit - 1].rstrip() + "…"


def sentence_spans(text: str) -> list[tuple[int, str]]:
    """Return approximate prose sentences with source offsets."""

    spans: list[tuple[int, str]] = []
    for match in re.finditer(r"[^.!?\n]+(?:[.!?]+|$)", text):
        sentence = match.group(0).strip()
        sentence = re.sub(r"^\s*(?:[-*+] |\d+[.)]\s+)", "", sentence)
        if sentence and re.search(r"[A-Za-z]", sentence):
            spans.append((match.start(), sentence))
    return spans


def word_count(sentence: str) -> int:
    tokens = re.findall(
        r"(?:CODE|URL)|(?:[A-Za-z0-9][A-Za-z0-9_./:+%#@=-]*(?:'[A-Za-z]+)?)",
        sentence,
    )
    return len(tokens)


def regex_findings(body: str) -> list[Finding]:
    checks = (
        (
            "MECH-CONTRACTION",
            "note",
            CONTRACTION_RE,
            "Expand contractions when the audience or controlled mode requires complete forms.",
        ),
        (
            "MECH-FILLER",
            "note",
            EMPTY_FILLER_RE,
            "Delete this phrase if it adds no fact.",
        ),
        (
            "MECH-INFLATED",
            "note",
            INFLATED_RE,
            "Replace this word with the concrete behavior, or remove the unsupported claim.",
        ),
        (
            "MECH-MODAL",
            "review",
            AMBIGUOUS_MODAL_RE,
            "Confirm whether this expresses permission, possibility, recommendation, requirement, or prediction before rewriting it.",
        ),
        (
            "MECH-ING-CLAUSE",
            "note",
            DANGLING_ING_RE,
            "Consider a new sentence with an explicit subject and relationship.",
        ),
    )
    findings: list[Finding] = []
    for code, severity, pattern, message in checks:
        for match in pattern.finditer(body):
            findings.append(
                Finding(
                    code=code,
                    severity=severity,
                    line=line_number(body, match.start()),
                    excerpt=compact_excerpt(match.group(0)),
                    message=message,
                )
            )

    for match in re.finditer(r";", body):
        findings.append(
            Finding(
                code="MECH-SEMICOLON",
                severity="note",
                line=line_number(body, match.start()),
                excerpt=";",
                message="Consider two sentences in controlled mode if the split preserves meaning.",
            )
        )
    return findings


def sentence_findings(body: str, kind: str) -> list[Finding]:
    findings: list[Finding] = []
    limit = LIMITS.get(kind)
    for offset, sentence in sentence_spans(body):
        count = word_count(sentence)
        if limit is not None and count > limit:
            findings.append(
                Finding(
                    code="MECH-LENGTH",
                    severity="review",
                    line=line_number(body, offset),
                    excerpt=compact_excerpt(sentence),
                    message=f"Approximate length is {count} words; the {kind} target is {limit}.",
                )
            )

        if kind == "procedure":
            lower = sentence.lower()
            condition = TRAILING_CONDITION_RE.search(lower)
            if condition and condition.start() > 0:
                prefix = sentence[: condition.start()].strip(" ,")
                if IMPERATIVE_HINT_RE.match(prefix):
                    findings.append(
                        Finding(
                            code="MECH-TRAILING-CONDITION",
                            severity="review",
                            line=line_number(body, offset),
                            excerpt=compact_excerpt(sentence),
                            message="If this clause is a prerequisite, put it before the action.",
                        )
                    )
    return findings


def terminology_findings(body: str) -> list[Finding]:
    findings: list[Finding] = []
    for label, terms in TERM_GROUPS.items():
        found: list[tuple[str, int]] = []
        for term in terms:
            match = re.search(rf"\b{re.escape(term)}\b", body, re.IGNORECASE)
            if match:
                found.append((term, match.start()))
        if len(found) > 1:
            terms_text = ", ".join(term for term, _ in found)
            first_offset = min(offset for _, offset in found)
            findings.append(
                Finding(
                    code="MECH-TERMINOLOGY",
                    severity="review",
                    line=line_number(body, first_offset),
                    excerpt=terms_text,
                    message=f"Review {label} for needless synonym rotation; keep distinct terms when meanings differ.",
                )
            )
    return findings


def analyze(text: str, kind: str) -> dict[str, object]:
    body = mask_markdown(text)
    findings = regex_findings(body)
    findings.extend(sentence_findings(body, kind))
    findings.extend(terminology_findings(body))
    findings.sort(key=lambda item: (item.line, item.code, item.excerpt.lower()))
    return {
        "kind": kind,
        "advisory_only": True,
        "summary": {
            "findings": len(findings),
            "review": sum(item.severity == "review" for item in findings),
            "notes": sum(item.severity == "note" for item in findings),
        },
        "findings": [asdict(item) for item in findings],
    }


def format_text(report: dict[str, object]) -> str:
    summary = report["summary"]
    assert isinstance(summary, dict)
    lines = [
        "Advisory mechanical check (not a compliance or semantic-fidelity verdict)",
        f"Kind: {report['kind']}",
        f"Findings: {summary['findings']} ({summary['review']} review, {summary['notes']} notes)",
    ]
    findings = report["findings"]
    assert isinstance(findings, list)
    for item in findings:
        assert isinstance(item, dict)
        lines.append(
            f"L{item['line']} {item['code']} [{item['severity']}]: "
            f"{item['excerpt']} — {item['message']}"
        )
    return "\n".join(lines)


def self_test() -> None:
    sample = (
        "Configure the client if the proxy is active; it's simply robust. "
        "You should verify the configuration settings before continuing, making recovery easier."
    )
    report = analyze(sample, "procedure")
    codes = {item["code"] for item in report["findings"]}
    expected = {
        "MECH-CONTRACTION",
        "MECH-FILLER",
        "MECH-INFLATED",
        "MECH-MODAL",
        "MECH-ING-CLAUSE",
        "MECH-SEMICOLON",
        "MECH-TRAILING-CONDITION",
        "MECH-TERMINOLOGY",
    }
    missing = expected - codes
    if missing:
        raise AssertionError(f"self-test missing checks: {sorted(missing)}\n{report}")

    protected = analyze("Run `tool --should-stay`; read https://example.com/may.", "procedure")
    protected_codes = {item["code"] for item in protected["findings"]}
    if "MECH-MODAL" in protected_codes:
        raise AssertionError(f"protected span was scanned: {protected}")
    print("self-test OK")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", nargs="?", default="-", help="UTF-8 text file, or - for stdin")
    parser.add_argument(
        "--kind",
        choices=("mixed", "procedure", "explanation"),
        default="mixed",
        help="Apply sentence targets only for procedure or explanation",
    )
    parser.add_argument("--format", choices=("text", "json"), default="text")
    parser.add_argument("--fail-on-findings", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    return parser.parse_args(argv)


def read_source(source: str) -> str:
    if source == "-":
        return sys.stdin.read()
    return Path(source).read_text(encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    if args.self_test:
        self_test()
        return 0

    report = analyze(read_source(args.source), args.kind)
    if args.format == "json":
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        print(format_text(report))

    count = report["summary"]["findings"]
    return 1 if args.fail_on_findings and count else 0


if __name__ == "__main__":
    raise SystemExit(main())
