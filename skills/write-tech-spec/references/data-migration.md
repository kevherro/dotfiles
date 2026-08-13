# Data Models and Migrations

Read this reference when a design changes a schema, persistent model, retained
data, storage ownership, or migration.

## Contents

1. Data contract
2. Derived and cached state
3. Migration state machine
4. Compatibility matrix
5. Common omissions

## 1. Data contract

For each durable entity or record, define:

- owner and source of truth;
- logical key, physical key, and uniqueness constraints;
- fields, types, units, nullability, defaults, and validation;
- lifecycle and legal state transitions;
- relationships and referential behavior;
- read and write paths;
- transaction or consistency boundary;
- indexes and the query shapes they serve;
- retention, archival, deletion, and legal hold;
- encryption, access control, audit, and residency;
- expected scale and growth assumptions;
- repair, reconciliation, export, and deletion tooling.

State which invariants are enforced by storage, application code, asynchronous
reconciliation, or operational procedure. Eventual enforcement must include the
violation window and repair behavior.

## 2. Derived and cached state

Specify:

- authoritative input and derivation function;
- refresh trigger and acceptable staleness;
- invalidation and race behavior;
- rebuild and corruption recovery;
- behavior when the derived store is missing;
- versioning when the derivation changes.

## 3. Migration state machine

Treat migration as explicit system behavior rather than a list of deploy steps.
Typical phases are:

1. add backward-compatible storage or interface support;
2. deploy readers that understand old and new forms;
3. deploy writers under a gate or in shadow mode;
4. backfill or convert historical state;
5. validate equivalence and invariants;
6. switch authoritative reads or writes;
7. observe through a defined safety window;
8. remove compatibility paths and obsolete state.

For every phase, specify:

- allowed reader and writer versions;
- source of truth;
- transformation and idempotency;
- progress and correctness metrics;
- pause, retry, abort, rollback, and roll-forward behavior;
- treatment of concurrent writes;
- treatment of malformed or unconvertible records;
- capacity, throttling, and production-load impact;
- who advances the phase and on what evidence.

Never assume rollback restores compatibility if new writers have persisted state
old readers cannot interpret. Name the last reversible point and the repair or
roll-forward plan after it.

## 4. Compatibility matrix

Enumerate combinations rather than describing only steady state:

| Reader | Writer | Data version | Expected behavior |
|---|---|---|---|
| old | old | old | baseline |
| old | new | old/new | ... |
| new | old | old | ... |
| new | new | old/new | target |

Include services, clients, automation, events in flight, caches, backups, and
restored snapshots when they cross the boundary.

Identify the mechanism that preserves compatibility: additive field, adapter,
wrapper, version tag, dual read/write, translation, shadow validation, or
coordinated cutover. Map each supported combination to a test.

## 5. Common omissions

Look for:

- uniqueness claimed without a concurrency boundary;
- indexes named without the query and write-cost consequence;
- old clients or readers omitted from mixed-version operation;
- backfills racing with live writes;
- unconvertible records with no quarantine or repair path;
- rollback that ignores newly persisted state;
- deletion that leaves replicas, indexes, caches, logs, or derived data;
- a schema diagram with no lifecycle or consistency semantics;
- a migration phase with no observable completion or owner;
- backups restored into a schema version that cannot read them.
