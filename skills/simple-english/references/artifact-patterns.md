# Artifact patterns
Read only the section that matches the requested artifact. Preserve the user's existing format when it already serves the purpose.

## Procedures and runbooks

Order the content as follows:

1. State the goal or expected end state.
2. State prerequisites that apply to the whole procedure.
3. Put warnings immediately before the risky step.
4. Give one independently executable action per numbered step.
5. Put a step-specific condition before its action.
6. State the observable success signal.
7. Give a bounded fallback when failure is possible.

Keep explanations outside numbered actions when they do not tell the reader what to do. Do not move an incidental descriptive `if` clause to the front unless it is a prerequisite for an action.
Convert a required, authorized action into its own imperative step. For example, split `Before you run X, do Y` into `Do Y. Then run X.` only when the procedure clearly intends the reader to run X. Keep X as context when the source does not authorize or require it. After every split, confirm that both events and their original force remain.

## Errors and recovery guidance

Use this information order:

1. State the failed operation or unavailable result.
2. State the cause only when evidence establishes it.
3. Give the smallest safe corrective action.
4. Give escalation guidance only when the first action can fail.

Do not add a guessed cause to make the message sound specific. Do not add a command, variable, or contact path that the source does not supply.

Example with complete source facts:

> Upload failed because the token lacks write access. Give the token write access, then upload the file again.

Example with an unknown cause:

> Upload failed. Read the request log for the failure reason.

## Warnings and destructive actions

Use a visible risk label when the artifact has such a convention. Put the instruction before the consequence:

> CAUTION: Export the audit file before you clear the queue. Clearing the queue permanently removes its pending jobs.

Preserve the source's risk severity. Do not promote inconvenience to data loss or demote a security or safety warning.

## Incident reports and status updates

Separate confirmed facts from interpretation:

1. State the time window and user-visible effect.
2. State the measured scope when supplied.
3. State the confirmed trigger or write that the cause remains under investigation.
4. State the mitigation and current status.
5. State a next action only when the source commits to it.

Retain appropriate empathy when the product voice requires it. Remove ceremonial filler before removing facts, accountability, or a useful next step.

## Release notes and migration notices

For each change, state:

1. what changed;
2. who or what is affected;
3. the required migration action, if any;
4. the deadline or version boundary, if supplied;
5. the consequence of no action, if supplied.

Do not invent a removal date, fallback behavior, compatibility guarantee, or performance number.

## API and architecture explanations

Describe one relationship at a time. Name the component, its action, and the object it acts on. Follow the actual data flow. Distinguish synchronous work, queued work, retries, persistence, and failure paths only when the source supports them.

Keep stable technical terms. Do not rotate between `worker`, `processor`, and `service` for variety when they identify the same component.

## Support and UI text

Lead with the user's state or next action. Keep buttons, labels, settings, and quoted messages exact. Give one recovery path at a time. Avoid blame, false reassurance, and generic apologies.

For empty states, say what is absent and give the next available action. Do not promise ease or speed unless evidence supports it.

## Agent instructions, prompts, and `AGENTS.md`

Define the outcome and completion bar before process detail. Keep these sections short:

- goal;
- success criteria;
- constraints and permission boundaries;
- tool-routing rules that depend on context;
- required output;
- retry, fallback, and stop conditions.

State each invariant once. Prefer decision rules to repeated absolute commands. Remove examples and process instructions that do not change behavior. Preserve exact commands, file paths, tool names, and schemas.

Do not turn a prose cleanup into a policy change. Compare the revised instruction set with the original permissions, side effects, and stopping conditions.

## Marketing and brand prose

Apply this workflow only when the user explicitly requests it. Preserve factual claims and the requested structure, but warn that controlled technical prose reduces rhythm, persuasion, humor, and brand voice. Offer a plain-language marketing pass instead of a controlled-mode pass when that better matches the goal.
