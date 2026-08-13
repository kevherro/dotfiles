# Verification Playbook

Use this playbook to choose evidence that matches the scope and risk of a code change. Treat commands as repository-specific; discover the authoritative commands instead of substituting familiar ones.

## Select checks by risk

| Change surface | Minimum relevant evidence |
| --- | --- |
| Local pure logic | Regression or behavior test, boundary cases, package tests, static checks. |
| Public API | Compile or type-check consumers, compatibility tests, examples and documentation. |
| Concurrency | Deterministic ordering tests where possible, stress or repetition, race detection, cancellation and shutdown checks. |
| Retries or distributed work | Duplicate delivery, reordering, timeout, partial completion, idempotency, and amplification checks. |
| Persistent data or migration | Forward migration, required backward path, interruption, mixed versions, rollback, and representative data. |
| Security boundary | Abuse cases, authorization and validation boundaries, failure-closed behavior, dependency or secret exposure checks. |
| Performance-sensitive path | Correctness tests plus matched before/after benchmarks with workload, environment, absolute results, and variance. |
| Build or toolchain | Clean build, supported platforms or configurations, generated-output stability, bootstrap or packaging checks. |
| UI or externally rendered artifact | Behavioral tests plus visual or rendered inspection at relevant states and sizes. |

Add broader tests when multiple surfaces interact. Do not cite one unit test as proof of a migration, compatibility, or distributed-systems requirement.

## Verify in increasing scope

1. **Baseline:** Demonstrate the bug or record the pre-change behavior when useful.
2. **Focused:** Run the smallest test that proves the changed rule.
3. **Component:** Run the owning package, module, or service checks.
4. **Interaction:** Run the cross-component checks implied by callers and risk.
5. **Repository:** Run the broad safe suite appropriate to the change.
6. **Artifact:** Inspect generated files, binaries, rendered output, schemas, or deployment plans.
7. **Diff:** Run whitespace/error checks and inspect the entire diff and status.

Run expensive checks after focused checks succeed, but leave enough time to fix what broad checks reveal.

## Classify failures with evidence

- **Caused by the change:** Reproduces on the changed tree and not on the baseline, with a plausible path through modified behavior.
- **Pre-existing:** Reproduces on the authoritative baseline under the same conditions.
- **Environmental:** Evidence identifies a missing dependency, unavailable service, permission, platform, or resource condition independent of the implementation.
- **Unknown:** Evidence is insufficient to assign another category.

Do not label a failure pre-existing or environmental merely because it appears unrelated. Reproduce the classification when safe.

## Keep a completion matrix

For non-trivial work, maintain this compact internal matrix:

| Requirement | Implementation evidence | Verification evidence | Status |
| --- | --- | --- | --- |
| Observable criterion | File, symbol, migration, or behavior | Exact command, test, trace, benchmark, or inspection | Proved, contradicted, missing, or uncertain |

Continue working on contradicted, missing, or uncertain rows. A requirement is proved only when the evidence covers its actual scope.

## Report verification precisely

In the final handoff, state:

- the exact checks run;
- whether each passed, failed, or could not run;
- the relevant scope of each check;
- any unverified platform, migration direction, workload, or integration;
- any failure classification supported by baseline evidence.

Do not dump routine logs. Preserve the commands and decisive results a maintainer would need to reproduce confidence.
