# Performance, Capacity, Overload, and Cost

Read this reference when latency, throughput, memory, storage, resource budgets,
overload, scaling, or cost are material.

## Performance contract

Define the user-visible or system quantity being protected: latency distribution,
throughput, allocation rate, memory, CPU, storage, network, build time, queue age,
or tail amplification.

### Workload and baseline

Specify:

- request or job mix and input-size distribution;
- concurrency, arrival pattern, and burst assumptions;
- dataset size, cardinality, and growth;
- cache state and warmup;
- hardware, region, dependency, and software versions;
- baseline measurement and uncertainty;
- target or budget and its authority.

Do not present a percentage without absolute values. Do not turn an unevidenced
target into an observed fact.

### Mechanism and hypothesis

Explain the causal path by which the design changes the measured quantity.
Estimate the relevant complexity or resource bound. Identify tradeoffs and the
metric most likely to regress.

For latency, account for tail behavior, queuing, retries, fan-out, cold paths,
and downstream limits. For memory or storage, account for retained and peak state,
not only steady-state averages.

### Pathological behavior

Specify worst plausible input, saturation behavior, feedback loops, and recovery.
Name bounds, admission controls, shedding, degradation, or circuit breaking that
prevent one slow or expensive path from consuming the system.

## Capacity and cost model

Create a simple model when scale is material:

- demand unit and peak demand;
- work or bytes per unit;
- capacity per instance, shard, partition, or region;
- headroom and failure reserve;
- scaling trigger, rate, and upper bound;
- bottleneck and dependency quota;
- backlog growth and time to drain;
- cost driver and budget sensitivity.

Label provisional inputs and say how they will be measured. If exact traffic or
distributions are unavailable, design the measurement and keep sizing
provisional instead of inventing values.

State behavior above capacity: reject, shed, degrade, queue, sample, or delay.
Include fairness between tenants or priorities when relevant.

## Validation

Define:

- benchmark or load-test harness and version;
- production-representative workload and its limitations;
- baseline and candidate comparison;
- sample count, warmup, duration, and variance treatment;
- correctness checks during load;
- metrics that must not regress;
- pass, fail, and investigation thresholds;
- production canary validation and rollback gate.

Separate measured results from predictions. Preserve unfavorable or neutral
results that challenge the design.

Classify missing measurements carefully. A current workload or platform fact is
design evidence only when it changes the selected mechanism, a safe bound, the
capacity model, or the acceptance method. If the design can define a formula,
measurement method, conservative disabled default, and passing gate without the
result, the later benchmark or canary result is implementation or rollout
evidence and does not prevent `implementation_ready`.

## Common omissions

Look for:

- average latency hiding tail or overload behavior;
- percentage improvement with no absolute baseline or workload;
- throughput target with no input-size distribution or dependency quota;
- retry or fan-out amplification omitted from capacity;
- steady-state sizing with no failure reserve or backlog drain time;
- a load test that checks speed but not correctness;
- a cost claim without its principal demand and storage drivers;
- a provisional target treated as a mandatory contradiction without authority.
