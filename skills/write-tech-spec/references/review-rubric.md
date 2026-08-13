# Tech-Spec Readiness Review

Use this reference to audit an existing specification and before assigning final
readiness to a substantial new or revised specification. The rubric supports
judgment; it does not replace the hard gates.

## Contents

1. Review method
2. Hard gates
3. Scored dimensions
4. Terminal states
5. Finding format
6. Final skeptical questions

## 1. Review method

1. Extract the authoritative decision contract and its source.
2. Extract every normative requirement, invariant, interface, and acceptance
   claim from the spec.
3. Trace each requirement to a mechanism and verification method.
4. Trace one success path, one failure path, one mixed-version or migration
   path, and rollback when applicable.
5. Compare the resulting behavior with the locked decision; search for silent
   product or policy changes.
6. Verify factual claims against available sources or visible assumption markers.
7. Have the status follow the evidence rather than the polish of the prose.

## 2. Hard gates

Do not assign `implementation_ready` unless every applicable gate passes.

### Decision fidelity

- The aligned outcome, closed choices, delegated choices, constraints, and
  non-goals are explicit or traceable.
- The design implements rather than re-litigates the settled direction.
- No implementation detail silently changes product semantics, policy, privacy,
  compatibility, or commercial behavior.
- Every new externally observable semantic is either fixed by authority or
  explicitly delegated; source silence is not treated as permission to invent.

### Authority and evidence

- Current behavior comes from authoritative current-system evidence.
- Desired behavior comes from the approved direction.
- Observed, decided, derived, assumed, and open claims are distinguishable.
- No material fact, number, owner, API, schema, incident, or compatibility claim
  is invented.
- Claims that depend on a platform's exact semantics are verified against
  primary documentation, inspected source, or a reproducible version-matched
  experiment before they support normative behavior or safety.

### Contract precision

- Inputs, outputs, states, errors, authorization, time, limits, and failure
  semantics are unambiguous at every material boundary.
- Ordering, concurrency, consistency, idempotency, retry, cancellation, and
  partial success are defined where applicable.
- Two competent implementers would produce materially compatible behavior.

### Mechanism and invariants

- Important invariants are testable.
- Every major mechanism has a parent requirement, invariant, or constraint.
- Component responsibilities, state ownership, data flow, persistence, and
  lifecycle are actionable.
- Pathological cases are bounded rather than dismissed.

### Compatibility and lifecycle

- Old and new clients, services, data, automation, and mixed versions are covered.
- Migration phases have entry, exit, validation, pause, and recovery behavior.
- Rollback accounts for new state and in-flight work.
- Irreversible points, cleanup, repair, and long-term ownership are explicit.

### Operability and safety

- Critical failures have detection, containment, recovery, and repair.
- Signals map to invariants, rollout gates, or operational decisions.
- Security, privacy, performance, capacity, and cost are addressed in proportion
  to actual risk.
- Ownership exists for rollout, operation, and unresolved material work.

### Verification and rollout

- Acceptance criteria are observable and mapped to tests or experiments.
- Workloads, baselines, environments, and uncertainty support quantitative claims.
- Rollout stages define passing criteria, evidence to collect, abort conditions,
  and safe next actions.
- No material design-time placeholder, evidence gap, or delegated design choice
  remains. Future implementation and rollout results are explicit gates, not
  false claims of already completed work.

## 3. Scored dimensions

Score each applicable dimension from 0 to 4:

- **4 — complete:** Implementers do not need a new material design decision.
- **3 — minor gap:** Only local, reversible detail remains.
- **2 — material gap:** A contract, mechanism, or lifecycle decision is ambiguous.
- **1 — restatement:** The text mostly repeats requirements or names components.
- **0 — contradiction:** It violates the aligned decision or fabricates authority.

Dimensions:

1. decision fidelity and scope;
2. current-system model and evidence discipline;
3. external contract precision;
4. internal mechanism and invariant traceability;
5. concurrency, failure, and recovery;
6. compatibility, migration, and rollback;
7. security, privacy, performance, capacity, and cost;
8. observability, validation, and rollout;
9. ownership, sequencing, and living documentation;
10. proportionality, clarity, and auditability.

For `implementation_ready`, decision fidelity, evidence discipline, external
contracts, and verification must score 4. Every other applicable dimension must
score at least 3, and all hard gates must pass. Do not average away a blocker.

## 4. Terminal states

Use the narrowest accurate state:

- `implementation_ready`: all hard gates pass and no material design invention
  remains for implementers. Required implementation, test, benchmark, and rollout
  results may still be future work when the spec fixes their method and passing
  criteria; readiness is permission to build, not proof that implementation or
  rollout is complete.
- `needs_evidence`: a current-state fact or design-time validation result needed
  to fix the design is missing. State what evidence is needed, how to obtain it,
  which design statement remains provisional, and what work can continue safely.
- `needs_technical_decision`: a material choice remains inside the aligned
  direction and cannot be resolved responsibly from current evidence. Present
  the narrow choice, criteria, recommendation if supportable, and owner.
- `needs_authoritative_clarification`: authoritative inputs conflict or leave
  product-visible behavior ambiguous. Ask only for the smallest clarification and
  preserve unaffected design work.
- `constraint_conflict`: authoritative evidence proves that a locked choice
  violates a mandatory security, legal, compatibility, platform, or technical
  invariant. Show the proof, impact, and smallest closed choice to reopen.
- `direction_not_aligned`: explicit invocation found no settled direction. Name
  the missing decision contract and hand off to a proposal or decision workflow
  without selecting a product direction.

A preferred alternative, missing owner, unknown traffic estimate, difficult
migration, stale dissent, or failed provisional target is not automatically a
`constraint_conflict`.

Do not demote a spec solely because named implementation files, test output,
benchmark reports, drills, dashboards, or production rollout evidence do not yet
exist. Put those deliverables under implementation or rollout gates. Demote it
only when a missing current fact changes a material mechanism, safety conclusion,
public contract, sizing choice, or acceptance method, and name the exact design
statement that remains conditional.

## 5. Finding format

Prioritize findings by consequence:

- **Blocker:** prevents compatible implementation, safe migration, reliable
  verification, or honest readiness.
- **Major:** likely to cause divergent implementation, production risk, or
  substantial rework.
- **Minor:** local ambiguity, weak evidence presentation, or maintainability issue
  that does not change the design.

For each finding, give:

1. precise location;
2. violated requirement, invariant, or gate;
3. concrete consequence or counterexample;
4. smallest corrective action or question.

Do not report generic preferences as findings. Consolidate repeated symptoms
under their common missing contract.

## 6. Final skeptical questions

- What must every conforming implementation do exactly the same way?
- Which claim would be most damaging if false, and where is its evidence?
- Where can one side commit while another cannot observe the result?
- What happens to state written immediately before rollback?
- Which old/new version combination has not been exercised?
- Can overload or retry create positive feedback?
- Can an expired, duplicated, or unauthorized actor still mutate state?
- Which invariant lacks a detection signal or acceptance test?
- Does an apparently local simplification move complexity to callers, migration,
  operations, or future maintainers?
- What would the second implementation team still have to invent?
- Which part of the historical design must become a maintained living contract?
