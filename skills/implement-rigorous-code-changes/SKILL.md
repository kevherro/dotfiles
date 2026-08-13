---
name: implement-rigorous-code-changes
description: Diagnose defects and implement requested patches or behavioral changes with an invariant-first, evidence-backed workflow inspired by Russ Cox's engineering practice, without imitating his voice. Use when Codex is asked to fix a bug, resolve a failing test, implement a supplied or described diff, change repository behavior, complete a focused code modification, or prove that a requested code change fully satisfies its acceptance criteria.
---

# Implement Rigorous Code Changes

Make each change easy to explain, test, and audit:

`observed behavior -> contract -> smallest witness -> failure mechanism -> coherent change -> executable evidence`

Transfer the engineering method, not Russ Cox's phrasing or persona. Prefer explicit invariants, small operational examples, bounded mechanisms, reproducible evidence, and compatibility over time.

## Orient before editing

1. Read applicable repository instructions and discover the authoritative build, test, formatting, and generation commands.
2. Inspect the working tree. Preserve unrelated user changes and avoid destructive cleanup.
3. Locate the implementation, tests, callers, data formats, configuration, and public contract touched by the request.
4. Inspect history only when it helps recover intent, compatibility constraints, or the origin of a behavior.
5. Restate the requested outcome as observable behavior.

Keep a compact internal evidence card:

- **Current behavior:** What happens now, and how is it known?
- **Required behavior:** What must a user, caller, test, or operator observe afterward?
- **Invariant:** What rule must hold across ordinary and boundary cases?
- **Proof obligation:** What evidence would demonstrate the complete request?
- **Risk surface:** Which callers, versions, stored data, concurrent operations, or external systems can be affected?

Share the card only when it exposes a material assumption the user should evaluate.

## Select the change track

- For a defect, regression, flaky failure, crash, or failing test, read [references/bug-fix-playbook.md](references/bug-fix-playbook.md).
- For a supplied patch, natural-language diff, feature adjustment, migration, or API behavior change, read [references/diff-implementation-playbook.md](references/diff-implementation-playbook.md).
- For any non-trivial change, read [references/verification-playbook.md](references/verification-playbook.md).

Use multiple playbooks when the request combines tracks.

## Scale effort to risk

For a local deterministic fix, keep the evidence card to a few lines, avoid unnecessary planning or delegation, make the focused change, run the decisive checks, and audit the diff. Do not turn a one-line fix into a research project.

Use the full playbooks when uncertainty, blast radius, compatibility, concurrency, persistence, security, performance, or distributed behavior justifies them.

## Delegate independent evidence work

When parallel work materially improves speed or confidence, delegate bounded read-heavy tasks such as repository mapping, reproduction, history analysis, consumer discovery, log inspection, or independent test-gap review.

- Use at most three workers unless the environment sets a lower limit.
- Give each worker a disjoint question and require a concise result with file references or verification evidence.
- Keep invariant decisions, scope changes, overlapping edits, and final diff ownership with the main agent.
- Delegate writes only when file ownership is clearly disjoint; inspect and integrate every result.
- Stop duplicate work and synthesize relevant findings before implementation or completion.

Keep straightforward or tightly coupled work in one agent.

## Establish behavior before mechanism

For a bug, reproduce the failure or obtain the strongest direct evidence before choosing a fix. Reduce the case until the first incorrect state transition, value, or side effect is visible.

For a requested diff, translate the request into observable acceptance criteria before editing. Treat patch text as implementation intent, not proof that the resulting repository is correct.

When reproduction is impossible, separate observed facts from causal inference. Proceed when the fix is well supported and safe, but state the missing evidence rather than widening the patch to compensate.

Ask for direction only when plausible interpretations would materially change public behavior, persisted data, security, compatibility, or intended scope. Otherwise make a reversible, stated assumption and continue.

## Derive the change

1. Identify the layer that owns the violated or requested invariant.
2. Choose the smallest coherent change that satisfies the entire behavior—not merely the smallest textual diff.
3. Prefer a direct mechanism whose correctness can be explained locally.
4. Avoid speculative abstractions, new dependencies, and adjacent cleanup unless required for correctness or lower total system complexity.
5. Trace relevant boundary values, error paths, cancellation, retries, partial completion, concurrency, ownership, and serialization.
6. Preserve backward compatibility unless the user explicitly requests a break; implement the in-scope migration and coexistence story when a break is required.
7. Update documentation, generated artifacts, fixtures, schemas, and examples when they form part of the changed contract.

Do not transfer complexity silently to callers, tests, deployment, operations, or future maintainers.

## Verify and prove completion

For a focused change, run the regression or behavior test, repository-required checks for the changed component, and a complete diff inspection. For a non-trivial change, use the verification playbook to select risk-matched checks and maintain a requirement-to-evidence matrix.

Treat completion as unproven until every acceptance criterion maps to authoritative implementation and verification evidence. Continue working on contradicted, missing, or uncertain criteria; a narrow green test does not prove a broader requirement.

Never claim a check passed unless it ran successfully. Classify failures as caused by the change, pre-existing, environmental, or unknown only when evidence supports the classification.

Before finishing, review the entire diff for omitted consumers, platforms, generated artifacts, migration directions, failure modes, unrelated edits, and rollback or mixed-version risks where applicable.

## Hand off the finished change

Lead with the outcome. Report:

1. The behavior changed and its mechanism or rationale.
2. The important files and tests.
3. The exact verification performed and its result.
4. Remaining limitations, unverified assumptions, or rollout considerations.

Keep the handoff proportional. Preserve the reasoning a maintainer needs; omit a diary of routine tool calls.
