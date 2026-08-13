# Controlled mode

Use this mode only when the user explicitly asks for controlled English, Simplified Technical English, ASD-STE100 style, strict sentence budgets, or a standards-oriented audit.

## State the boundary

Describe the result as a best-effort structural rewrite or audit. Do not claim ASD-STE100 certification or full compliance. Full vocabulary and part-of-speech review requires authoritative standard material and qualified human review.

Do not invent official rule numbers or dictionary rulings. If the user supplies an authorized standard excerpt, cite only the supplied identifiers and apply only the relevant text.

## Apply the structural profile

- Target no more than 20 words for an instruction.
- Target no more than 25 words for an explanation.
- Treat those budgets as hard limits only when the user requests strict limits.
- Give one independently executable action per procedural sentence.
- Give one main fact or relationship per explanatory sentence.
- Use complete grammar. Do not remove articles or necessary instances of `that` merely to shorten text.
- Prefer simple present, simple past, simple future, infinitives, and imperatives.
- Prefer active voice when the actor is known and relevant.
- Avoid contractions in strict output.
- Split a semicolon into two sentences when that preserves meaning.
- Use a list for a sequence or for several parallel conditions.
- Keep terminology stable across the artifact.
- Put a prerequisite before the action that depends on it.
- Put a warning before the risky action and state the supplied consequence.

Do not apply an instruction rule to an explanatory conditional. Classify locally.

## Preserve modal meaning

Interpret modal words before rewriting them:

- requirement -> retain `must` or the source's binding term;
- prohibition -> retain `must not`, `do not`, or the source's binding term;
- permission -> state that the action is permitted without making it required;
- recommendation -> keep it optional and give the reason when supplied;
- possibility -> preserve uncertainty;
- prediction or commitment -> preserve the stated confidence and time.

Do not mechanically replace `may`, `might`, `could`, `should`, `can`, `will`, or `must`. Ask a focused question when the intended force changes safety, access, cost, or obligations.

## Handle vocabulary

Use common words when they preserve precision. Retain necessary technical nouns and verbs. Define a term on first use when the audience needs the definition.

Choose one label for one concept, but preserve distinctions such as:

- authentication versus authorization;
- validation versus verification;
- error versus failed operation;
- configuration source versus runtime option.

Delete inflated words only when they add no fact. Replace a vague claim such as `robust` with a supplied measurable behavior. If no behavior is supplied, remove the claim rather than inventing one.

## Validate strict output

1. Compare every fact and protected span with the source.
2. Run the advisory checker with the correct dominant kind.
3. Inspect every finding in context.
4. Count the longest procedural and explanatory sentences manually when exact limits matter.
5. Recheck modality, uncertainty, conditions, and causal claims after every split.

If accuracy conflicts with a strict surface rule, preserve accuracy and report the conflict. Do not hide the conflict with a misleading rewrite.

## Attribution and status

This skill is an unofficial writing aid. ASD-STE100 is associated with ASD, and automated tools do not provide official certification or endorsement. Consult [the ASD-STE100 site](https://www.asd-ste100.org/) for authoritative material and current terms of use.
