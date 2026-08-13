# Distributed Behavior and Operations

Read this reference when the design includes asynchronous work, concurrency,
queues, retries, caching, replication, coordination, partial failure,
multi-region behavior, or staged deployment. Use only the relevant sections.

## Contents

1. Model state and ownership
2. Specify concurrency and consistency
3. Bound retries and work
4. Design for partial failure
5. Handle caching, replication, and regions
6. Operate, deploy, and recover
7. Common omissions

## 1. Model state and ownership

List durable and ephemeral state, then name its owner. For each state transition,
define:

- initiator and authorization;
- precondition and atomicity boundary;
- durable commit point;
- externally visible acknowledgment point;
- legal successor states;
- timeout, cancellation, and orphan behavior;
- reconciliation or repair owner.

Use a state table when prose hides illegal transitions:

| Current state | Event / condition | Next state | Durable effects | External effect |
|---|---|---|---|---|

Avoid two components both believing they own the same transition. If ownership
is intentionally shared, specify the arbitration rule.

## 2. Specify concurrency and consistency

For every shared object or decision, answer:

- What can execute concurrently?
- What ordering, if any, is guaranteed and within what scope?
- What isolation or consistency can readers observe?
- How are lost updates, duplicate work, and stale decisions prevented or
  detected?
- What fencing or version token prevents an expired owner from writing?
- How does cancellation race with commit?
- Which operations are commutative, idempotent, or compensatable?

Name the actual mechanism: transaction, compare-and-swap, lease plus fencing
token, single-writer partition, immutable log, conflict resolution, or periodic
reconciliation. `The service handles races` is not a mechanism.

### Time and leases

Distinguish elapsed time from wall-clock timestamps. State clock-skew assumptions
and what happens when they fail. A lease without a fencing mechanism may prevent
cooperative owners but not a paused or partitioned former owner.

## 3. Bound retries and work

Specify retry behavior end to end:

- which layer owns retry;
- retryable conditions and ambiguity after timeout;
- maximum attempts, elapsed budget, backoff, and jitter;
- idempotency mechanism and retention window;
- amplification across nested retries;
- dead-letter, quarantine, compensation, or human repair;
- cancellation and priority propagation;
- observability of attempts versus logical operations.

Compute a worst-case amplification bound when multiple layers retry. Prefer one
clear retry owner per boundary.

For queues and workers, also define admission, concurrency limits, visibility or
lease duration, redelivery, poison work, backlog age, draining, and shutdown.

## 4. Design for partial failure

Trace failures at every boundary where one side can commit and the other cannot
observe the result.

Use this table:

| Failure point | State left behind | Caller observation | Detection | Safe recovery |
|---|---|---|---|---|

Include:

- dependency timeout before and after remote commit;
- process crash between local steps;
- partial batch success;
- unavailable control plane with a healthy data plane, and the reverse;
- dropped, delayed, duplicated, or reordered messages;
- exhausted storage, memory, threads, connections, or quotas;
- reconciliation failure and growing repair backlog.

State whether the system fails open, fails closed, degrades, sheds load, queues
work, or rejects it. Tie the choice to an invariant.

### Overload and backpressure

Define:

- admission and fairness policy;
- queue and concurrency bounds;
- load-shedding order;
- behavior at saturation;
- retry guidance that avoids synchronized amplification;
- recovery after backlog accumulation;
- signals for demand, utilization, saturation, and errors.

An unbounded queue converts overload into latency and memory failure; it does not
solve overload.

## 5. Handle caching, replication, and regions

### Caches

Specify source of truth, key scope, fill strategy, invalidation, staleness bound,
negative entries, stampede control, eviction, and behavior during cache failure.
Define how authorization and tenant boundaries are represented in keys.

### Replication

Specify replication direction, acknowledgment rule, consistency, lag behavior,
conflict handling, failover, recovery, and data-loss envelope. Identify what
state is not replicated.

### Multi-region operation

Define traffic ownership, placement, routing, locality, failover authority,
split-brain prevention, recovery point objective, recovery time objective, and
failback. Trace behavior during a network partition rather than only complete
regional outage.

## 6. Operate, deploy, and recover

### Observability

Map signals to decisions:

- invariant violation and correctness drift;
- logical requests versus attempts;
- saturation and backpressure;
- queue depth and oldest age;
- retries, timeouts, deduplication, and dead letters;
- replication or migration lag;
- degraded-mode entry and exit;
- repair progress and unresolved residue.

State threshold, evaluation window, and responsible owner when known. Avoid
listing telemetry that no rollout gate, alert, or investigation will use.

### Deployment

Specify version ordering, feature gates, configuration propagation, mixed-version
behavior, draining, and rollback. Control-plane and data-plane changes may need
different order and independent rollback.

Distinguish an unknown current integration contract from a future deployment
proof. The former can block the design when component boundaries cannot yet be
specified. A propagation test, failure drill, canary result, or soak report that
the finished implementation must pass is a rollout gate, not evidence required
to call the design ready to implement.

### Recovery

Define backups, restoration, replay, reconciliation, data repair, regional
failover, and disaster exercises according to risk. State how restored state is
validated before traffic resumes.

## 7. Common omissions

Look specifically for:

- acknowledgment before the durable commit it claims;
- retry at several layers with no shared budget;
- idempotency key without scope, storage, expiry, or concurrency semantics;
- lease without fencing;
- cancellation after an irreversible effect with no caller contract;
- queue with no bound, poison-item policy, or drain behavior;
- cache invalidation that ignores authorization or tenant scope;
- failover that permits two writers;
- reconciliation described without progress, alerting, or terminal repair;
- rollback that cannot interpret new state or in-flight work;
- metrics that count attempts as successful logical operations;
- recovery claims that have no restoration test.
