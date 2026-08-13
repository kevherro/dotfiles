# Audit rubric

Use these local IDs for findings. They are workflow labels, not ASD-STE100 rule numbers.

| ID | Check | Failure condition |
|---|---|---|
| `SE-01` | Semantic fidelity | A rewrite adds, removes, strengthens, weakens, or changes a fact or relationship. |
| `SE-02` | Protected literals | Code, identifiers, commands, labels, numbers, citations, or quoted text change without authorization. |
| `SE-03` | Actor and action | The reader cannot identify who does what, or an instruction is not independently executable. |
| `SE-04` | Conditions and order | A prerequisite, exception, warning, or action sequence is misplaced or unclear. |
| `SE-05` | Modality and uncertainty | Requirement strength, permission, possibility, recommendation, or evidence strength changes. |
| `SE-06` | Terminology | One concept has needless names, or distinct concepts are collapsed into one name. |
| `SE-07` | Sentence load | A sentence or paragraph carries too many claims, actions, or nested clauses for the audience. |
| `SE-08` | Grammar and reference | A pronoun, modifier, abbreviation, contraction, or omitted word creates ambiguity. |
| `SE-09` | Structure and navigation | Information order, headings, lists, or paragraph boundaries obscure the reader's task. |
| `SE-10` | Evidence boundary | The text invents a cause, remedy, metric, date, guarantee, example, or product behavior. |

## Audit procedure

1. Record protected spans and source facts.
2. Classify blocks independently as explanations, instructions, warnings, reference data, or literals.
3. Compare each sentence with the rubric.
4. Assign severity:
   - **critical:** can cause an unsafe, destructive, unauthorized, or factually false action;
   - **major:** changes meaning or blocks correct action;
   - **minor:** increases reading effort without changing meaning.
5. Suggest the smallest revision that fixes the finding.
6. Recheck the proposed revision against `SE-01`, `SE-02`, `SE-05`, and `SE-10`.

## Audit output

Lead with the overall result. Then use this table:

| Severity | ID | Source excerpt | Problem | Suggested revision |
|---|---|---|---|---|

Use short excerpts. Omit the table when there are no findings. If the user asks for a rewrite too, put the revised artifact before the audit unless the requested format says otherwise.

## Fidelity comparison

Compare source and revision for each category:

- names, actors, objects, and ownership;
- negation and exclusivity;
- numbers, units, dates, versions, and thresholds;
- obligations, prohibitions, permissions, recommendations, and options;
- uncertainty, estimates, hypotheses, and confirmed facts;
- prerequisites, exceptions, chronology, and action order;
- causes, correlations, effects, risks, and mitigations;
- code, commands, paths, identifiers, links, citations, and quotations.

Treat a missing source fact as a failure even when the revision sounds clearer. Treat a new plausible detail as unsupported until evidence establishes it.

## Mechanical support

Run `scripts/check_simple_english.py` for files or long controlled-mode drafts. Map its results to the rubric as follows:

- long sentence or dense construction -> inspect under `SE-07`;
- contraction or vague filler -> inspect under `SE-08`;
- trailing procedural condition -> inspect under `SE-04`;
- modal or terminology warning -> inspect under `SE-05` or `SE-06`.

Do not report a script match as a violation without reading the sentence in context. The script cannot detect semantic drift, clear grammar, valid domain usage, or compliance.
