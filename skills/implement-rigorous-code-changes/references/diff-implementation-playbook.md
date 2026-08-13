# Diff-Implementation Playbook

Use this playbook to implement literal patches, described code edits, or behavioral changes without confusing the requested text with the complete contract.

## Classify the request

- **Literal patch:** The user supplied exact hunks or a patch file.
- **Structural diff:** The user named files, types, functions, or transformations but not exact lines.
- **Behavioral diff:** The user specified an externally visible before-and-after result.
- **Cross-cutting change:** The request spans APIs, generated code, schemas, configuration, deployment, or multiple consumers.

Use the most behavioral interpretation that the request supports. A literal patch still requires build and test integration; a behavioral request requires deriving the implementation.

## Build an acceptance map

Translate the request into observable criteria before editing:

| Criterion | Owning location | Consumers or risks | Proof |
| --- | --- | --- | --- |
| Required behavior | File, package, service, or schema | Callers, versions, data, operations | Test, build, trace, benchmark, or inspection |

Include negative requirements such as "must not change wire format" or "must preserve existing callers." Keep implementation preferences separate from behavior requirements.

## Inspect the change neighborhood

Read enough context to understand:

- the full function, type, or configuration block;
- direct callers and implementations of changed interfaces;
- tests and fixtures that express current behavior;
- generated sources and their inputs;
- serializers, migrations, version gates, feature flags, and documentation;
- platform-specific or build-tagged variants.

Use repository search rather than guessing from filenames. Do not assume the visible hunk names every consumer.

## Apply the requested change faithfully

For a literal patch:

1. Confirm the patch targets the current code and contains no unintended path or mode changes.
2. Apply only the requested hunks when they fit cleanly.
3. Resolve context drift by preserving the patch's behavior, not by forcing stale text.
4. Report any material adaptation.

For a described or behavioral diff:

1. Implement every acceptance criterion at its owning layer.
2. Match established repository patterns unless they violate the requested invariant.
3. Avoid unrelated cleanup and speculative generalization.
4. Include required callers, tests, documentation, generated artifacts, and migrations in the same coherent change.

Do not reduce the scope merely to obtain a passing narrow test. Complete the full requested behavior.

## Account for evolution

When changing a public API, protocol, file format, configuration, or persistent schema, answer:

- Can old callers use the new implementation?
- Can new callers coexist with old implementations?
- Are stored values forward- and backward-readable as required?
- Is rollout ordered, gated, or reversible?
- Are defaults versioned when behavior changes?
- What happens during partial deployment or interrupted migration?

Prefer additive or version-gated evolution when it meets the request. If a breaking change is intentional, make the break explicit and migrate all in-scope consumers.

## Test the diff as behavior

- Add focused tests for each acceptance criterion.
- Preserve existing tests unless the requested contract makes them obsolete.
- Update golden files and snapshots only after explaining each meaningful difference.
- Regenerate derived files from their source rather than editing both independently.
- Test deleted or rejected behavior when its absence matters.
- Exercise mixed-version, migration, or platform cases when the risk surface includes them.

## Audit scope and completeness

Before finishing:

1. Compare the final diff with the acceptance map.
2. Search again for missed consumers and obsolete names.
3. Confirm no placeholder, compatibility shim, temporary flag, or generated artifact was left incomplete.
4. Inspect the diff for unrelated formatting or user-owned changes.
5. Record criteria lacking direct proof and continue until the evidence matches the request.
