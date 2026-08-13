# Document Shapes

Use only the sections that help the reader. Rename them to match the subject instead of copying these labels mechanically.

## Technical explainer

1. **The concrete puzzle**
   - Show the smallest input, trace, program, or diagram that exhibits the behavior.
   - Ask the exact question the article will answer.
2. **The operational model**
   - Define the components and rules needed to reason about the example.
   - State what the model intentionally omits.
3. **The mechanism**
   - Walk the example through the model.
   - Add complexity one feature or abstraction layer at a time.
4. **The implementation**
   - Provide minimal code or pseudocode.
   - Connect each important line to the model.
5. **The evidence**
   - Show a test, benchmark, trace, proof, or production observation.
   - Give the baseline and reproduction conditions.
6. **The boundary**
   - Explain unsupported cases, tradeoffs, and failure modes.
7. **The conclusion**
   - State what readers can now rely on and what remains uncertain.

## Proposal or RFC

1. **Recommendation** — State the proposed change in one paragraph.
2. **Demonstrated problem** — Use incidents, measurements, support burden, or a small counterexample to establish significance.
3. **Design criteria** — List the invariants and constraints that a solution must preserve.
4. **Proposed mechanism** — Derive the design from those criteria; include the important data flow or state transitions.
5. **Alternatives** — Present the strongest alternatives and why they do not satisfy the same criteria.
6. **Compatibility and migration** — Cover existing users, versioning, rollout, rollback, stored data, and mixed-version operation.
7. **Operations** — Cover observability, failure behavior, security, ownership, and maintenance.
8. **Validation** — Specify experiments, acceptance criteria, and unresolved evidence.
9. **Decision** — Name the decision-maker, requested decision, and deadline when appropriate.

## Incident or security analysis

1. **Summary** — State what happened, impact, affected interval, and present status without speculation.
2. **Initial evidence** — Show the symptom that led to investigation.
3. **Mechanism** — Trace the relevant request, process, data, or trust boundary step by step.
4. **Scope** — Separate confirmed impact, ruled-out impact, and unknown impact.
5. **Chronology** — Include only events that changed system state, understanding, or response.
6. **Contributing conditions** — Distinguish trigger, root mechanism, and organizational or defensive gaps.
7. **Correction** — Explain how the immediate issue was contained and repaired.
8. **Prevention and verification** — Connect each action to a specific failure mode and say how completion will be tested.

Avoid dramatic adjectives, attacker mind-reading, and claims stronger than the evidence. Preserve raw commands, hashes, timestamps, and logs when they matter for reproducibility.

## Performance report

1. **Question** — Name the user-visible or system-level quantity being improved.
2. **Workload** — Define inputs, traffic shape, dataset, concurrency, warmup, and environment.
3. **Baseline** — Give the current result and measurement uncertainty.
4. **Hypothesis** — Explain the mechanism expected to change the result.
5. **Change** — Describe only implementation details relevant to that mechanism.
6. **Results** — Report absolute numbers before percentages; include regressions and unchanged metrics.
7. **Interpretation** — Separate measurements from causal inference.
8. **Limits** — State where the benchmark differs from production and what remains unmeasured.
9. **Decision** — Recommend ship, revise, expand testing, or stop.

## Short decision memo

Use this order when readers need a decision more than a tutorial:

1. Recommendation.
2. Two or three decisive facts.
3. Main tradeoff and strongest rejected alternative.
4. Compatibility, operational, and ownership consequences.
5. Requested decision and next action.

Keep supporting derivations in an appendix, but preserve enough causal explanation that the recommendation remains auditable.

## Structural rewrite

When revising an existing draft:

1. Extract every substantive claim into a scratch outline.
2. Pair each claim with its evidence, qualification, or missing-proof marker.
3. Identify one running example and one central argument.
4. Choose a document shape above.
5. Reorder claims into the causal or derivational sequence.
6. Rewrite transitions after the structure is stable.
7. Restore useful voice and texture without restoring clutter.
