---
name: coxify
description: Draft, rewrite, or review technical prose with a derivation-first, evidence-backed method inspired by Russ Cox's public technical writing, without imitating his exact voice. Use for design documents, RFCs, architecture memos, technical blog posts, API or algorithm explanations, postmortems, migration plans, and performance, reliability, or security writeups; also use when prose needs to become clearer, more concrete, historically grounded, reproducible, or easier to audit.
---

# Write Rigorous Technical Prose

Produce prose that lets readers reconstruct the argument instead of merely accepting its conclusion. Preserve the author's voice and facts while applying a Cox-inspired explanatory method.

Do not simulate Russ Cox's authorship, reproduce distinctive passages, or force recognizable catchphrases. Transfer the high-level craft: concrete examples, explicit invariants, stepwise derivation, working evidence, useful history, and attention to software over time.

## Establish the assignment

Before drafting, identify:

1. The audience and what they already know.
2. The decision, understanding, or action the document should enable.
3. The central claim and the smallest concrete example that exposes the problem.
4. The facts, measurements, code, incidents, or sources that support each important claim.
5. The constraints, unknowns, and disagreements that must remain visible.

Proceed with clearly labeled assumptions when missing context does not change the document's direction. Ask for clarification only when a missing fact would materially change the argument. Never invent measurements, citations, history, incidents, or implementation details. Mark unresolved evidence with a specific placeholder such as `[NEEDS: p95 latency before and after the change]`.

## Choose a document shape

Select the closest shape and adapt it rather than forcing every section into the result:

- **Technical explainer:** problem -> tiny example -> operational model -> mechanism -> evidence -> limits -> conclusion.
- **Proposal or RFC:** demonstrated problem -> design criteria and invariants -> proposed mechanism -> alternatives -> migration and compatibility -> operations and risks -> decision.
- **Incident or security analysis:** observed symptom -> impact and scope -> precise mechanism -> chronology -> contributing conditions -> correction -> prevention and verification.
- **Performance report:** workload and question -> baseline -> hypothesis -> mechanism -> measurement method -> results -> interpretation -> limits and next step.
- **Short decision memo:** recommendation -> decisive evidence -> tradeoffs -> implementation consequences -> requested decision.

Read [references/document-shapes.md](references/document-shapes.md) when drafting a long document, choosing among forms, or turning raw notes into a new structure.

## Build the argument

1. Open with the actual technical problem and why it matters. Avoid generic scene-setting.
2. Introduce one small running example. Prefer an example that reveals the failure, boundary, or surprising behavior with minimal machinery.
3. Define only the terms needed to reason about that example.
4. State the important invariants and constraints explicitly.
5. Derive the mechanism one step at a time. Move down abstraction layers gradually: interface -> representation -> operation -> observed result.
6. Attach evidence near the claim it supports. Use minimal runnable code, commands with expected output, measurements with baselines, diagrams, incidents, or primary sources as appropriate.
7. Explain rejected alternatives and where they move complexity. Distinguish facts, inferences, preferences, and open questions.
8. Account for the whole system over time: compatibility, migration, debugging, operations, maintenance, security, and coordination with other people.
9. Use history only when it explains the present design, recovers a useful idea, or documents how a failure mode arose.
10. End with the exact conclusion the evidence supports, followed by remaining limitations or the next decision.

## Write plainly

- Prefer direct, declarative sentences and concrete nouns.
- Earn a strong thesis with visible evidence.
- Use a question or claim to orient each substantial section.
- Keep one idea per paragraph; make the first sentence carry the paragraph's purpose.
- Define jargon on first use or replace it with ordinary language.
- Keep code examples minimal and runnable. Include the relevant result.
- State benchmark workload, environment, baseline, units, and important variance.
- Describe security issues mechanistically and scope claims precisely; avoid alarmist language.
- Use diagrams or tables only when they clarify relationships that prose obscures.
- Allow occasional dry playfulness when natural, but never at the expense of precision.
- Avoid throat-clearing, adjective stacks, vague intensifiers, ceremonial summaries, and excessive headings.
- Do not use phrases such as "simple and fast" or "boring is good" merely to evoke Cox.

## Revise in the right order

For a rewrite, recover the thesis, evidence, and reasoning before polishing sentences. Make structural edits first, paragraph edits second, and line edits last.

Run this audit:

- Can the thesis be stated in one sentence?
- Does the opening example expose the real problem?
- Can a skeptical reader follow every inference?
- Does every important factual claim have evidence or a visible qualification?
- When the draft says "simple," does it say simpler for whom, along which dimension, and over what time span?
- Does a local simplification merely transfer complexity to users, tools, migration, or operations?
- Are alternatives, failure modes, compatibility costs, and limitations represented fairly?
- Can a reader reproduce the code path, experiment, benchmark, or calculation?
- Does every historical detail perform technical work?
- Can any paragraph, heading, example, or flourish be removed without losing meaning?

## Return useful output

- For a new draft, return the complete prose plus a short list of unresolved evidence gaps, if any.
- For a revision, preserve the author's facts, position, and appropriate workplace tone; do not turn every document into a blog post.
- For a critique, prioritize argument structure, missing evidence, and unjustified leaps before sentence-level style.
- For an executive audience, retain the causal mechanism but compress derivations and move supporting detail into clearly named appendices.
