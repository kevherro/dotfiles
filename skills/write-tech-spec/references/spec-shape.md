# Adaptive Tech-Spec Shape

Use this reference to draft or structurally rewrite a full implementation-level
technical specification. Select the sections the decision needs. Rename and
combine them to match the system; do not preserve empty headings.

## Contents

1. Establish the front matter
2. Import the aligned decision
3. Model the current system
4. State the design frame
5. Specify target behavior
6. Derive the mechanism
7. Design failure and change over time
8. Make the result operable and verifiable
9. Scale the document
10. Write for auditability

## 1. Establish the front matter

Make document state and authority visible near the title:

- status: `implementation_ready`, `needs_evidence`,
  `needs_technical_decision`, `needs_authoritative_clarification`,
  `constraint_conflict`, or `direction_not_aligned`;
- authors and responsible owners;
- reviewers or approving authorities when known;
- last updated date;
- links to the approved proposal, ADR, requirements, issue, or decision record;
- implementation tracker and living specification when they already exist.

Do not call a spec approved merely because its source proposal was approved.
Proposal alignment fixes direction; the detailed design still needs its own
readiness evidence.

## 2. Import the aligned decision

Create a compact decision contract:

- **Accepted outcome:** the capability or behavior that must exist.
- **Success criteria:** measurable or inspectable results inherited from the
  decision.
- **Closed choices:** product, API, architecture, or policy decisions this spec
  must not silently revisit.
- **Delegated choices:** decisions the sources explicitly give this spec, plus
  internal choices that cannot change any external commitment.
- **Unresolved authoritative choices:** observable behavior omitted by the
  sources and not explicitly delegated; isolate these for clarification rather
  than filling them by convention.
- **Constraints:** compatibility, policy, timing, platform, cost, security, or
  organizational boundaries.
- **Non-goals:** tempting adjacent work explicitly excluded.

Link to the full rationale. Repeat only enough motivation to let an implementer
understand the technical consequences.

Silence is not delegation for behavior visible to users, callers, operators,
auditors, stored-data readers, or other systems. Small-looking choices such as an
HTTP status, absent-versus-empty value, normalization rule, exact retention
boundary, or authorization error can be product or compatibility decisions.

## 3. Model the current system

Explain the machine that will be changed, not the organization's entire history.

Include the smallest useful combination of:

- component and ownership map;
- representative request, data, or control flow;
- existing APIs, schemas, events, state, and configuration;
- current invariants, limits, and failure behavior;
- deployment topology and version relationships;
- relevant code locations, tests, telemetry, and incidents.

Trace one concrete operation through the model. Label observations and
inferences. Identify where the proposed behavior enters, exits, stores state, or
crosses a trust or ownership boundary.

## 4. State the design frame

### Goals and non-goals

Write goals as observable outcomes. Write non-goals precisely enough to prevent
scope from re-entering under another name.

### Invariants

State rules that must remain true across success, failure, deployment, and
rollback. Prefer quantified or testable statements. Group them when useful:

- semantic correctness and state integrity;
- ordering, uniqueness, durability, and consistency;
- compatibility and mixed-version behavior;
- security and privacy;
- performance, capacity, and cost;
- debuggability, recovery, and operability.

### Assumptions and constraints

Distinguish externally imposed constraints from design preferences. Attach
evidence or a validation plan to assumptions whose failure changes the design.

## 5. Specify target behavior

Start with contracts observable outside the implementation:

- exact inputs, outputs, errors, and authorization;
- APIs, commands, events, schemas, configuration, and defaults;
- state machine and legal transitions;
- ordering, consistency, idempotency, time, and retry semantics;
- limits, quotas, timeouts, and cancellation;
- versioning and compatibility rules;
- concrete normal, boundary, and failure examples.

Use normative language consistently. If `MUST`, `SHOULD`, and `MAY` are used,
define whether they are requirements or ordinary emphasis.

State what a caller can rely on independently of the chosen implementation.

## 6. Derive the mechanism

Move from contract to implementation in causal order:

1. Assign component responsibilities and ownership.
2. Show control and data flow for the representative operation.
3. Define persistence, indexing, caching, concurrency, and consistency.
4. Explain algorithms, policies, thresholds, and lifecycle transitions.
5. Connect every major mechanism to a requirement, invariant, or constraint.
6. Work at least one normal and one adverse example through the design.

Call out deliberately unspecified internals when interoperability does not depend
on them. Do not promise an implementation detail as a public contract by
accident.

### Remaining alternatives

Compare only decisions still delegated to this spec. For each serious option,
record:

- criteria it satisfies or violates;
- complexity it creates for callers, implementation, migration, or operations;
- reversibility and future constraints;
- evidence, prototype, or experiment supporting the choice.

Record the chosen mechanism plainly. Avoid a fake alternatives section containing
only obviously inferior straw men.

## 7. Design failure and change over time

### Failure behavior

Define detection, containment, recovery, and repair for the failures that matter.
A useful table is:

| Failure | Observable effect | Detection | Containment | Recovery / repair |
|---|---|---|---|---|

Include partial success and ambiguous outcomes. Say who or what owns retry and
how repeated recovery attempts remain safe.

### Compatibility and migration

Specify:

- compatibility boundary and translating mechanism;
- old/new reader and writer combinations;
- stored-data evolution and validation;
- deployment ordering and mixed-version duration;
- feature gates, shadowing, dual operations, or backfill where needed;
- abort criteria, rollback semantics, irreversible points, and cleanup.

Treat migration as a state machine. For every phase, say what may read, write,
retry, roll back, and advance the phase.

## 8. Make the result operable and verifiable

### Observability and operations

Tie signals to invariants and failure modes. Specify metrics, logs, traces, audit
records, dashboards, alerts, inspection tools, runbooks, and ownership only where
they serve a concrete decision or response.

State expected steady state, degraded state, overload behavior, and recovery.

### Validation

Map acceptance evidence to claims:

| Claim or invariant | Test / experiment | Environment and workload | Passing criteria / evidence |
|---|---|---|---|

Cover the relevant mix of unit, integration, contract, compatibility, migration,
load, failure-injection, security, and manual operational testing.

Label evidence by lifecycle:

- **design evidence:** facts that must be known before the contract, mechanism,
  safety conclusion, sizing decision, or acceptance method can be fixed;
- **implementation evidence:** tests, benchmarks, migrations, and integrations
  produced while building;
- **rollout evidence:** canary, soak, propagation, and production results used to
  advance exposure.

Only the first category can make the design `needs_evidence`. The latter two are
future gates in an `implementation_ready` specification. If design evidence is
missing, name the exact design statement that remains conditional.

### Rollout

Separate:

- prerequisites and foundation;
- first usable increment;
- progressive exposure or migration stages;
- observable gates between stages;
- abort, rollback, and roll-forward behavior;
- completion and cleanup criteria.

### Ownership and living documentation

Name component, rollout, and operational owners when known. Identify which parts
of the historical design will become a maintained API, protocol, schema, or
subsystem specification beside the implementation.

## 9. Scale the document

For a small, reversible change with one owner, the minimum viable spec can be:

1. decision contract;
2. current-to-target delta;
3. exact behavior and failure semantics;
4. compatibility and rollout;
5. verification and open questions.

For a cross-cutting or irreversible change, expand the derivation, migration
state machine, failure analysis, evidence, and operational design. Length is not
a quality metric; unambiguous coordination is.

## 10. Write for auditability

- Open sections with the claim or question they answer.
- Keep current and target behavior visually distinct.
- Place evidence next to the claim it supports.
- Use diagrams for topology or sequence and tables for exact mappings; do not use
  them as decoration.
- Keep examples small enough to verify.
- Preserve uncertainty with owned, consequential open questions.
- Prefer direct sentences and concrete nouns over architectural adjectives.
- Remove history, alternatives, or implementation detail that no longer changes
  a reader's decision.
- Follow repository formatting conventions. One sentence per source line and
  narrow wrapping are useful only when the repository chooses them for review.
