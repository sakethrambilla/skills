---
name: executing-plans
description: Executes an existing implementation plan task by task, keeping mutable state in progress.md, verifying each task against its own stated command before moving on, and stopping to report when reality diverges from the plan. Use when a plan.md, tasks directory, or implementation plan already exists and the user says to start, continue, resume, or "work through" it — and use it after the writing-implementation-plans skill hands off.
---

# Executing plans

The plan is intent and stays fixed. `progress.md` is state and changes constantly. Never edit the plan to record what happened; never rely on the plan to remember where you are.

## Start

Read `plan.md` — the index only, not every task file. Then create or open `progress.md` alongside it:

```markdown
# Progress — <feature>

**Plan:** ./plan.md
**Status:** in progress
**Current:** Task 2

## Log
- 2026-09-05 Task 1 — done, commit a1b2c3d. Suite green.
- 2026-09-05 Task 2 — in progress.

## Deviations
- Task 1 step 3: plan said `src/auth/limit.ts`, actual path is
  `src/auth/rateLimit.ts`. Used the real path.

## Blocked / needs a decision
- (none)
```

If `progress.md` already exists, it — not the plan, and not your recollection — is the source of truth for where things stand. Resume from `Current`.

## The loop

For each task, in order:

1. Read that one task file. Not the others.
2. Execute its steps in sequence. Do not batch steps or skip the "confirm it fails" step — running the test before the implementation is what proves the test is connected to the behaviour.
3. Run the task's stated verification command. Compare against the stated expected output.
4. Commit as the task specifies.
5. Append a line to the log in `progress.md` with the commit hash and the verification result.

Then stop and report before starting the next task, unless the user has said to run straight through. A short report — task name, what changed, verification result, anything surprising — is what makes the next review cheap.

## When verification fails

Fix the code, not the test, and not the expectation. Changing an assertion to match the output is how a suite becomes decorative.

Two failures on the same task means stop and think rather than trying a third variation. Read the actual error, form a hypothesis about the cause, and check the hypothesis before editing. Most repeated failures are the second-order effect of a wrong assumption two steps earlier, and another quick edit will not surface it.

If the fix is still not obvious, report to the user with the error, what you've ruled out, and what you think is happening. That is more useful than a fourth attempt.

## When reality diverges from the plan

Plans are written before the code is read closely, so divergence is normal and not a failure.

**Small divergence** — a path is wrong, a helper already exists, a signature differs slightly. Adapt, and record it under Deviations with one line saying what the plan said and what you did.

**Large divergence** — the approach doesn't work, a task turns out to depend on something not in the plan, or the spec's acceptance criterion can't be met the planned way. Stop. Do not improvise a new architecture mid-execution; that is exactly the failure planning was meant to prevent. Report what you found and what it implies, and let the user decide whether to amend the plan or the spec.

The test for which one you're in: if you'd need to change the plan document to describe what you're about to do, it's large.

## Fresh-context execution

When subagents are available, prefer dispatching one per task. Send the task file contents and the plan's global constraints — not the whole plan, not the conversation history. A subagent with 2k tokens of focused instruction outperforms one carrying 40k tokens of accumulated context, and the coordinating session stays lean enough to run the whole plan without compacting.

Have the subagent report back a short summary: what changed, verification result, deviations. Write that into `progress.md` yourself.

## Finish

When the last task is done:

1. Run the full test suite and the lint/typecheck commands from the plan header.
2. Walk the spec's acceptance criteria one at a time and state, for each, the evidence that it's met — which test, which command, which observed behaviour. This is the step that catches "all tasks done, feature doesn't work."
3. Set `Status: complete` in `progress.md` and summarize deviations for the user.

Report anything from the plan that turned out to be wrong. That feedback is what makes the next plan better, and it is lost the moment the session ends.
