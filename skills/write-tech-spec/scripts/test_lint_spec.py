#!/usr/bin/env python3
"""Regression tests for the tech-spec mechanical linter."""

from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("lint_spec.py")
SPEC = importlib.util.spec_from_file_location("lint_spec", MODULE_PATH)
assert SPEC and SPEC.loader
lint_spec = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = lint_spec
SPEC.loader.exec_module(lint_spec)


class LintSpecTests(unittest.TestCase):
    def lint(self, text: str, root: Path) -> tuple[str | None, list[object]]:
        path = root / "TECH_SPEC.md"
        path.write_text(text, encoding="utf-8")
        lines = lint_spec.visible_lines(text)
        status, findings = lint_spec.detect_status(lines)
        findings.extend(lint_spec.check_markers(lines, status))
        findings.extend(lint_spec.check_empty_sections(lines))
        findings.extend(lint_spec.check_local_links(lines, path, root))
        return status, findings

    def test_clean_ready_spec(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            status, findings = self.lint(
                "# Design\n\nStatus: `implementation_ready`\n\n## Contract\n\nExact.\n",
                Path(directory),
            )
        self.assertEqual(status, "implementation_ready")
        self.assertEqual(findings, [])

    def test_ready_spec_rejects_unresolved_marker(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            _, findings = self.lint(
                "# Design\n\nStatus: `implementation_ready`\n\n"
                "[OPEN: choose the wire error]\n",
                Path(directory),
            )
        self.assertIn(
            ("error", "unresolved-marker"),
            {(item.severity, item.code) for item in findings},
        )

    def test_nonready_marker_is_informational(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            _, findings = self.lint(
                "# Design\n\nStatus: `needs_evidence`\n\n"
                "[NEEDS EVIDENCE: current transport type]\n",
                Path(directory),
            )
        self.assertEqual(
            [(item.severity, item.code) for item in findings],
            [("info", "unresolved-marker")],
        )

    def test_code_fence_does_not_create_placeholder_finding(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            _, findings = self.lint(
                "# Design\n\nStatus: `implementation_ready`\n\n"
                "```go\n// TODO: implementation task\n```\n",
                Path(directory),
            )
        self.assertNotIn("placeholder", {item.code for item in findings})

    def test_broken_link_and_empty_section_are_warnings(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            _, findings = self.lint(
                "# Design\n\nStatus: `needs_technical_decision`\n\n"
                "[missing](missing.md)\n\n## Empty\n",
                Path(directory),
            )
        self.assertTrue(
            {"broken-local-link", "empty-section"} <= {item.code for item in findings}
        )

    def test_multiple_status_fields_are_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            _, findings = self.lint(
                "# Design\n\nStatus: `needs_evidence`\n\n"
                "Status: `implementation_ready`\n",
                Path(directory),
            )
        self.assertIn("multiple-status", {item.code for item in findings})


if __name__ == "__main__":
    unittest.main()
