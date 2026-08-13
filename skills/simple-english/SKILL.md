---
name: simple-english
description: Draft, rewrite, or audit technical and operational prose in plain, unambiguous English while preserving facts, requirements, uncertainty, structure, and literal technical text. Use when the user asks for simple or plain English, controlled English, Simplified Technical English or ASD-STE100-style writing, clearer instructions for non-native readers, translation-ready technical text, less ambiguous procedures, or removal of AI-sounding filler from documentation, runbooks, error messages, incident updates, release notes, support text, prompts, and API guidance. Do not trigger for generic writing, code simplification, marketing or brand voice, or creative prose unless the user explicitly requests this treatment.
---

# Simple English

Make technical prose fast to understand and difficult to misread. Preserve meaning before improving style.

## Define success

Finish only when all applicable conditions are true:

- Preserve every supplied fact, limitation, relationship, and required action.
- Preserve requirements, prohibitions, permissions, recommendations, optionality, and uncertainty at their original strength.
- Preserve literal technical text exactly unless the user explicitly makes it the rewrite target.
- Make actors, actions, conditions, sequence, and consequences easy to identify.
- Use one term for one concept without collapsing meaningful distinctions.
- Preserve the requested artifact, language, structure, length, genre, and voice unless the user asks to change them.
- Add no unsupported cause, remedy, example, metric, date, guarantee, or product behavior.

Accuracy, safety, and semantic fidelity outrank brevity and sentence-length targets.

## Select the operation

- **Draft:** Create prose only from supplied or verified facts. Mark a material information gap instead of filling it.
- **Rewrite:** Revise supplied prose. Return only the revised artifact unless the user requests commentary.
- **Audit:** Keep the source unchanged. Report findings with the local `SE-*` IDs in `references/audit-rubric.md`.
- **Annotated rewrite:** Return the revision, material assumptions, unresolved ambiguities, and a compact change summary.

If the user asks to edit a file, edit the in-scope prose and validate the file. Do not change code behavior as part of a prose request.

## Select the writing mode

- **Plain mode (default):** Improve clarity and flow while retaining valid domain vocabulary and the requested voice. Treat sentence lengths as targets, not gates.
- **Operational mode:** Use for procedures, runbooks, warnings, recovery steps, and error guidance. Optimize for correct action under time pressure.
- **Controlled mode:** Use only when the user explicitly requests controlled English, Simplified Technical English, ASD-STE100 style, strict sentence budgets, or a compliance-oriented audit. Read `references/controlled-mode.md` before writing.

Classify each block independently. A document can contain an explanation, a warning, and a procedure without forcing all three into one style.

## Follow the workflow

### 1. Establish the writing contract

Infer the audience, artifact type, purpose, locale, and output constraints from the request and source. Ask one focused question only when the answer changes safety, permissions, obligations, data loss, cost, or the required action. Otherwise, use the least-assumptive interpretation.

Do not browse merely to rewrite supplied prose. Retrieve sources when the user asks for fact-checking, when required facts are missing, or when the artifact must reflect current external information.

### 2. Freeze protected material

Record these spans before editing:

- code blocks and inline code;
- identifiers, commands, flags, paths, URLs, endpoints, API fields, configuration keys, and UI labels;
- quoted errors, logs, user messages, and source quotations;
- names, versions, numbers, units, dates, percentages, links, citations, and reference labels.

Keep each span byte-for-byte exact. Treat prose inside a code comment, quoted string, or UI label as editable only when the user explicitly places it in scope.

### 3. Build a preservation ledger

List the source's claims and relationships before rewriting. Include:

- actors and objects;
- explicit and implicit actions, plus their original force and order;
- conditions, exceptions, thresholds, and scope;
- causes versus correlations;
- known facts versus uncertainty;
- requirements, recommendations, permissions, and prohibitions;
- risks, consequences, and mitigations.

If the source contradicts itself, expose the conflict. Do not silently reconcile it. If an actor, cause, or remedy is unknown, preserve that absence.

### 4. Plan the information order

Classify each block as explanation, instruction, warning, reference data, or protected literal text. Preserve headings and numbering unless a different structure materially improves the task or the user requests one.

Choose a canonical term for each repeated concept. Retain project-defined terminology. Keep separate terms when they carry separate technical meanings.

For a specialized artifact, read `references/artifact-patterns.md` and use only the relevant section.

### 5. Rewrite from outcomes and evidence

- Lead with the conclusion, state, or action that the reader needs.
- Use a concrete subject and verb when the actor is known.
- Put one main claim in a sentence and one independently executable action in a procedural step.
- Put a prerequisite before the action that depends on it. Do not move descriptive conditionals merely because they contain `if` or `when`.
- Preserve both events when splitting a dependency such as `before`, `after`, or `until`. Do not drop the primary action or promote background context into a new command.
- Put a warning immediately before the risky action. Name the consequence without exaggeration.
- Prefer short, familiar words, but retain precise domain terms. Define an unfamiliar term on first use when the audience needs it.
- Replace inflated wording with the underlying fact. Delete filler only when it carries no meaning.
- Use lists for sequences, alternatives, or three or more parallel items.
- Give pronouns clear referents. Keep articles and other grammar that prevent ambiguity.
- Preserve modality. Never turn `may`, `might`, `can`, `should`, `must`, or `will` into a stronger or weaker claim without evidence.
- Preserve uncertainty that informs the reader. Remove only empty hedging.
- Preserve causal boundaries. Do not convert correlation, suspicion, or sequence into a confirmed cause.

Prefer a complete sentence over telegraphic brevity. Prefer a precise longer sentence over a shorter sentence that changes meaning.

### 6. Validate before delivery

Compare the draft with the preservation ledger:

1. Match every entity, number, condition, exception, requirement, risk, and uncertainty statement.
2. Confirm that protected material is exact.
3. Confirm that instructions remain executable in the correct order.
4. Confirm that each repeated concept uses stable terminology without erasing real distinctions.
5. Remove repetition, vague referents, ornamental transitions, and unsupported claims.
6. Check sentence load and mechanical patterns.

For file-based work or controlled mode, run:

```bash
python3 <skill-dir>/scripts/check_simple_english.py --kind mixed <file>
```

Use `--kind procedure` or `--kind explanation` when the file has one dominant block type. Treat the checker as an advisory mechanical pass. It cannot verify meaning, grammar, or standards compliance. Fix applicable findings, then repeat the semantic comparison.

Stop when the artifact meets the writing contract and no material ambiguity remains. Do not keep rewriting only to make the prose shorter.

## Return the requested output

- For a draft or rewrite, return only the requested artifact by default.
- For an audit, use the response shape in `references/audit-rubric.md`.
- For a file edit, summarize the edited files and the validation performed.
- For an explicit standards-compliance request, state the controlled-mode boundary without claiming certification.

## Boundaries

- Do not invent official ASD-STE100 rule numbers, dictionary entries, certification, or endorsement.
- Do not claim that this workflow guarantees comprehension or prevents every misreading.
- Do not flatten marketing, literary, humorous, or brand writing unless the user explicitly accepts that tradeoff.
- Do not simplify legal, medical, security, safety, or policy terms by changing their defined meaning.
- Do not use a mechanical checker as proof of semantic fidelity or compliance.

This workflow is an original synthesis informed by controlled-language practice and the MIT-licensed [SimpleEnglish project](https://github.com/AminBlg/SimpleEnglish). It does not reproduce the ASD-STE100 dictionary or official rule catalog and is not affiliated with ASD.

## Resources

- `references/artifact-patterns.md`: Load the relevant section for procedures, errors, incidents, release notes, API or architecture text, support copy, and agent instructions.
- `references/audit-rubric.md`: Load for audits, annotated rewrites, or high-risk fidelity checks.
- `references/controlled-mode.md`: Load only for explicit controlled-English, STE, sentence-budget, or compliance-oriented requests.
- `scripts/check_simple_english.py`: Run as an advisory mechanical check on a file or standard input.
