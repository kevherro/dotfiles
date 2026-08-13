# APIs and Protocols

Read this reference when a design changes an API, command, event, callback, job,
or wire protocol. Specify behavior at the boundary before handler or storage
internals.

An omitted caller-visible detail is not automatically delegated to the technical
writer. Before selecting a status code, error, authorization rule, default,
presence semantic, normalization rule, time boundary, or compatibility behavior,
trace authority that fixes it or explicitly delegates that class of choice. If
neither exists, isolate it as `needs_authoritative_clarification`; do not make a
conventional-looking value normative by guesswork.

## Operation contracts

For each operation, define:

- name, purpose, caller, and authority;
- request shape, field types, units, constraints, and defaults;
- response shape and postconditions;
- validation order when it affects observable behavior;
- error taxonomy, stability, and retryability;
- idempotency scope and key lifetime;
- timeout, deadline, cancellation, and partial-result behavior;
- pagination, ordering, filtering, and list consistency;
- quotas, limits, and overload response;
- version negotiation and deprecation.

Use exact declarations or schemas. Include one successful request and the most
important invalid, duplicate, stale, unauthorized, and partially completed
cases.

### Time and identity

State:

- clock source, timestamp meaning, precision, timezone, and skew assumptions;
- identifier generation, uniqueness scope, stability, and information leakage;
- whether omitted, null, empty, and zero are distinct;
- canonicalization and comparison rules.

Verify platform-specific time, Unicode, serialization, numeric, and presence
semantics against primary documentation or a reproducible check for the exact
version in scope. For example, do not infer whether a database `day` means a
calendar day or a fixed duration, or whether a protocol preserves field
presence, from memory. When policy does not fix the desired observable meaning,
request the meaning before choosing the platform mechanism.

### Error contract

Do not expose implementation exceptions as an accidental protocol. For each
stable error class, specify:

- machine-readable code;
- caller-visible message policy;
- whether retry can succeed and under what condition;
- whether the operation may already have taken effect;
- diagnostics or correlation identifier;
- compatibility expectations for clients.

## Events, jobs, and callbacks

Define:

- producer and consumer ownership;
- envelope and payload schema;
- message identity and deduplication scope;
- delivery guarantee actually provided;
- ordering scope and behavior after gaps or reordering;
- acknowledgment point and redelivery condition;
- retry budget, quarantine, dead-letter, and replay controls;
- schema compatibility and unknown-field behavior;
- retention, expiration, and deletion;
- authorization, authenticity, and confidentiality;
- backpressure and overload behavior.

Avoid saying `exactly once` unless the end-to-end effect is proved exactly once.
Usually specify at-least-once delivery plus an idempotent effect, or name the
narrower boundary at which uniqueness is guaranteed.

Work these traces explicitly when relevant:

1. producer succeeds and acknowledgment is lost;
2. message is delivered twice concurrently;
3. consumer commits state and crashes before acknowledgment;
4. old consumer receives a new field or variant;
5. replay occurs after dependent state has changed.

## Compatibility

Enumerate caller/client and server combinations that can occur during rollout.
Define unknown-field, unknown-enum, old-error, and capability-negotiation
behavior. Include generated clients, automation, retained messages, and callbacks
that may outlive one deployment.

Name the preserving mechanism: additive change, adapter, version tag, negotiated
capability, or coordinated cutover. A compatibility claim without a mechanism
and contract tests is incomplete.

## Common omissions

Look for:

- unspecified null, empty, duplicate, or unknown values;
- validation and authorization performed in an unsafe order;
- errors whose retryability or commit ambiguity is unknown;
- unstable ordering or pagination across concurrent changes;
- timestamps with no clock or timezone semantics;
- events with no identity, replay, retention, or poison-item contract;
- generated clients or consumers omitted from compatibility testing;
- an idempotency key without scope, persistence, expiry, or concurrency rules;
- exact-once wording that covers transport but not the side effect.
