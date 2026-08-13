# Security and Privacy

Read this reference when trust boundaries, sensitive data, abuse, binding policy,
legal constraints, or privacy are material. Treat security as mechanisms tied to
assets and invariants, not as a generic threat list.

## Security model

Identify:

- assets and security invariants;
- principals, roles, tenants, and administrative powers;
- entry points and trust boundaries;
- trusted computing base and external dependencies;
- attacker capabilities in and out of scope;
- credentials, keys, secrets, and their lifecycle;
- high-impact abuse or misuse paths;
- binding policy, legal, or compliance constraints.

Trace representative operations across trust boundaries. For each boundary,
specify authentication, authorization, integrity, confidentiality, replay
protection, validation, rate limits, and audit behavior as applicable.

### Authorization

Define subject, resource, action, policy source, evaluation point, cache behavior,
and revocation latency. State whether existence can be revealed to unauthorized
callers. Include administrative and service-to-service paths.

### Secrets and keys

Specify generation, distribution, storage, access, rotation, revocation,
expiration, backup, and compromise recovery. Never place real secret material in
the specification.

### Abuse and resource control

Consider enumeration, amplification, replay, quota evasion, tenant interference,
poison data, and expensive inputs. Define bounds and attribution so mitigation
does not rely on an unidentified caller.

### Failure policy

State where the system fails closed, fails open, degrades, or queues work. Tie
the choice to safety and availability invariants. Include behavior when identity,
policy, key, or audit dependencies are unavailable.

## Privacy and data lifecycle

For personal, confidential, regulated, or tenant data, define:

- purpose and data minimization;
- collection source and user or tenant expectations;
- classification and field-level sensitivity;
- access, sharing, and processor boundaries;
- encryption in transit and at rest where required;
- residency and transfer constraints;
- retention, deletion, archival, backup, and legal hold;
- logging, tracing, analytics, and debugging redaction;
- export, correction, and deletion behavior;
- audit evidence and ownership.

Trace deletion through primary storage, replicas, indexes, caches, queues,
derived data, logs, analytics systems, backups, and restored snapshots. State
delayed or exceptional deletion behavior explicitly.

## Validation

Choose according to risk:

- authorization and tenant-isolation tests;
- malformed input, replay, and abuse tests;
- secret scanning and dependency review;
- audit-log completeness and tamper behavior;
- threat-model or security-owner review;
- key rotation and compromise exercise;
- privacy deletion and export verification;
- failure tests for identity, key, and policy dependencies.

## Common omissions

Look for:

- a threat list with no assets, trust boundaries, or mechanisms;
- authorization described as authentication;
- cached authorization with no revocation semantics;
- secrets that can be created but not rotated or revoked;
- sensitive values copied into logs, metrics labels, traces, or examples;
- deletion scoped only to the primary table;
- encryption claimed without key ownership or recovery;
- a binding contradiction softened into an ordinary risk instead of escalated.
