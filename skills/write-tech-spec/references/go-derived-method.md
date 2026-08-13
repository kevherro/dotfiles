# Go-Derived Implementation-Spec Method

Use this reference for examples of the reasoning method behind this skill. The
goal is not to imitate Go's proposal process, headings, or voice. Transfer the
craft that makes detailed designs auditable.

## Contents

1. Separate alignment from implementation
2. Explain the current machine
3. Derive mechanisms from invariants
4. Specify executable semantics
5. Make compatibility a mechanism
6. Stage the smallest proving architecture
7. Maintain a living contract
8. Technique index
9. Avoid cargo culting

## 1. Separate alignment from implementation

The Go profile-guided optimization work provides a useful artifact split:

- [High-level PGO design](https://github.com/golang/proposal/blob/master/design/55022-pgo.md)
  owns the accepted user workflow, profile format, build behavior,
  reproducibility, stale-profile tolerance, and stability requirements.
- [PGO implementation design](https://github.com/golang/proposal/blob/master/design/55022-pgo-implementation.md)
  elaborates compiler phases, data structures, pass ordering, algorithms,
  thresholds, code locations, and staged delivery.

Begin a tech spec with the aligned decision and inherited constraints. Link to
the rationale. Do not re-prosecute whether the capability should exist.

## 2. Explain the current machine

The PGO implementation design explains the existing compilation and inlining
flow before introducing the changed flow. Go's
[compiler README](https://github.com/golang/go/blob/master/src/cmd/compile/README.md)
and [SSA README](https://github.com/golang/go/blob/master/src/cmd/compile/internal/ssa/README.md)
likewise establish stages, representations, ownership boundaries, debugging
tools, and test surfaces.

Transfer the pattern:

1. reconstruct the current request, data, or control path;
2. identify exact insertion and replacement points;
3. show the target path as a transformation of the current model;
4. include only current-state detail that changes or verifies the design.

## 3. Derive mechanisms from invariants

The high-level PGO design names reproducible builds, tolerance of stale profiles,
and stability of the build–deploy–profile loop. The implementation chooses cache
key treatment, function-relative locations, weighted call graphs, and bounded
inlining in service of those properties.

The [internal ABI design](https://github.com/golang/proposal/blob/master/design/27539-internal-abi.md)
separates stable and unstable calling conventions, preserves old assembly through
wrappers, and states garbage-collector and stack-growth requirements before
optimizing argument passing.

Give every major mechanism a parent invariant. If no accepted requirement,
invariant, or constraint demands a component, challenge why it exists.

## 4. Specify executable semantics

The living [Go internal ABI specification](https://github.com/golang/go/blob/master/src/cmd/compile/abi-internal.md)
defines stability, terms, data layout, a numbered assignment algorithm,
preconditions and postconditions, architecture-specific behavior, and worked
examples.

Choose the equivalent precision for the target system:

- schema and state ownership;
- state machines and transitions;
- API, message, and configuration contracts;
- ordering, retry, idempotency, and concurrency rules;
- algorithms or pseudocode;
- error and partial-failure semantics;
- concrete normal and edge examples.

A reader should be able to implement compatible behavior without guessing.

## 5. Make compatibility a mechanism

The internal ABI design does not merely claim compatibility. It defines ABI
aliases and wrappers, maps affected definitions and references, identifies unsafe
exceptions, and stages a transition in which old and new conventions initially
behave identically.

The [register calling convention design](https://github.com/golang/proposal/blob/master/design/40724-register-calling.md)
builds on that boundary with an MVP, ABI bridges, compiler and runtime changes,
and deliberate deferrals.

For a generic system, identify:

- the old contract and compatibility boundary;
- the adapter, version, dual path, or translating mechanism;
- unsupported combinations and failure behavior;
- tests that prove the supported matrix;
- removal conditions for the compatibility mechanism.

## 6. Stage the smallest proving architecture

Go's internal ABI began with behavior identical to the old ABI and soaked before
diverging. Register calling began with a bounded architecture MVP. PGO first
landed enough profile plumbing and guided inlining to validate the design while
deferring later optimizations.

Separate required foundation, first usable increment, later expansion, feature
controls, observable gates, rollback, and cleanup. This is architectural risk
control, not project-management decoration.

## 7. Maintain a living contract

A proposal or design document preserves why a change was made. The internal ABI
specification describes the behavior that current implementations must obey and
lives beside the compiler.

Plan three artifacts when the design warrants them:

1. alignment record — why and what was approved;
2. implementation design — how it will be built and introduced;
3. living contract — current protocol, format, API, or subsystem behavior.

State which parts of the implementation spec must graduate into living
documentation and who owns the update.

## 8. Technique index

| Need | Exemplar | Technique |
|---|---|---|
| Separate accepted behavior from compiler mechanics | PGO design pair | Import constraints; elaborate implementation |
| Preserve legacy behavior while changing internals | Internal ABI design | Stable boundary plus translating wrappers |
| Specify a precise internal contract | Internal ABI specification | Algorithm, tables, pre/postconditions, examples |
| Stage a cross-cutting implementation | Register calling convention | MVP, impact map, bridges, deliberate deferrals |
| Document the machine engineers will change | Compiler and SSA READMEs | Pipeline, representation, ownership, tests |

## 9. Avoid cargo culting

- Do not copy Go's proposal headings into every implementation spec.
- Do not imitate line wrapping or one-sentence-per-line formatting as a quality
  signal; follow the target repository.
- Do not import Go's compatibility promise. State the actual system contract.
- Do not freeze volatile current behavior in a historical design when it needs a
  maintained specification.
- Do not reproduce compiler or ABI mechanisms outside analogous systems.
- Do not make every change require a large document; scale precision to risk and
  coordination cost.
- Do not repeat settled product alternatives. Preserve only local mechanism
  choices that remain open.
- Verify proposal-era constants, pseudocode, and paths against current code
  before treating them as implemented truth.
