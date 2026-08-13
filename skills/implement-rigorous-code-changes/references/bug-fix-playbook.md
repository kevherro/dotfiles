# Bug-Fix Playbook

Use this playbook to turn a symptom into a causal explanation, a regression test, and a fix at the layer that owns the broken invariant.

## Reproduce precisely

1. Record the exact actual result, expected result, input, environment, and invocation.
2. Run the existing failing test or command before editing when safe.
3. Preserve seeds, timestamps, versions, feature flags, and concurrency settings needed to reproduce nondeterminism.
4. Confirm that the failure is in scope rather than an unrelated dirty-worktree or environment problem.

If reproduction is expensive, isolate a cheaper probe that observes the same incorrect transition.

## Minimize the witness

Reduce the failing case without removing the behavior:

- delete irrelevant input records or syntax;
- replace integrations with the narrowest faithful boundary;
- reduce concurrency while preserving the ordering;
- remove unrelated configuration and feature flags;
- convert a system failure into a package or unit test when the same invariant is exercised.

Do not minimize past the real bug. A tiny test of a different behavior is not a reproduction.

## Find the first divergence

Trace backward from the bad output until the first state, value, branch, or side effect that differs from the contract. Prefer the earliest causal divergence over the final visible symptom.

Choose a localization tactic based on evidence:

| Situation | Tactic |
| --- | --- |
| Known good and bad revisions | Bisect version history with an automated predicate. |
| Large failing input | Binary-search or delta-debug the input. |
| Many optional transforms, rules, or call sites | Bisect the enabled set or execution sites using stable identifiers. |
| Similar passing and failing tests | Compare traces, logs, or differential coverage. |
| Small finite state space | Exhaustively enumerate it. |
| Independent implementation exists | Run differential tests against it. |
| Failure is timing-dependent | Preserve seeds and schedules; add tracing, stress, or race checks. |
| Performance regression | Bisect revisions and compare matched benchmark distributions. |

Automate the predicate before a long bisection. Re-run boundary points to detect flakiness.

## State the mechanism

Write a causal chain before patching:

`precondition -> implementation choice -> invalid intermediate state -> observable failure`

Verify each arrow using code, a test, a trace, or a documented contract. Avoid labels such as "race condition" or "cache issue" without identifying the exact conflicting operations or stale value.

## Design the regression test

Make the test an executable statement of the invariant:

- fail on the unfixed implementation;
- pass on the fixed implementation;
- exercise the public or owning-layer behavior when practical;
- include the boundary that made the bug possible;
- produce a readable failure;
- reject at least the obvious incomplete fix.

For a previously fixed bug that cannot be reverted safely, justify failure-before evidence with the original reproduction, a temporary mutation, or direct inspection of the old revision.

## Fix the owning layer

Correct the first invalid transition when possible. Avoid suppressing the final symptom while leaving corrupted state or repeated side effects intact.

Check whether the same mechanism appears in sibling code, but expand the patch only when the shared invariant and evidence justify it. Record follow-up opportunities without silently turning the fix into a refactor.

## Handle special failures

- **Concurrency:** Define permitted orderings, ownership, synchronization, cancellation, and race-free publication. Test adverse ordering rather than relying on sleeps.
- **Retries and distributed work:** Check idempotency, retry budgets, duplicate delivery, partial completion, timeouts, and reordering.
- **Security:** Identify the trust boundary and attacker-controlled value; verify failure is closed and scope claims match evidence.
- **Persistent data:** Test both migration directions, mixed versions, interruption, and rollback when required.
- **Performance:** Preserve correctness first; measure the actual workload with a baseline and report absolute results.

## Proceed when reproduction is unavailable

Separate:

- what was directly observed;
- what the code proves can happen;
- what is inferred but unconfirmed;
- what evidence would raise or lower confidence.

Prefer adding observability or a targeted guard when the causal mechanism remains uncertain. Do not manufacture certainty in the final handoff.
