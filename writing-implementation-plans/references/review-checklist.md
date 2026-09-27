# Plan review checklist

Run this before showing the plan to the user. If a subagent is available, hand it this file plus the plan and spec paths and ask for a written report — the author of a plan is the worst reviewer of it.

Report findings as a list of specific defects with locations. "The plan looks good" is not a review; if nothing is wrong, name the three things you checked hardest.

## Coverage

- [ ] Every acceptance criterion in the spec maps to at least one task. List the mapping explicitly — criterion number → task number. Gaps show up immediately in this form.
- [ ] Every task traces back to something in the spec. A task with no spec ancestor is scope creep that got in during planning.
- [ ] Non-goals from the spec are not being implemented anywhere.
- [ ] At least one task covers a failure path, not just the happy path.

## Executability

- [ ] No placeholders anywhere: "TBD", "TODO", "as needed", "appropriate", "handle errors", "etc."
- [ ] Every file reference is a real path. Paths invented from the spec rather than read from the repo are the most common defect — spot-check three.
- [ ] Every function or type referenced either exists in the repo or is created by an earlier task in this plan.
- [ ] Type and signature consistency across task boundaries: what task 1 produces is exactly what task 2 consumes, same names, same shapes.
- [ ] Dependencies between tasks are stated, and the ordering respects them.

## Verifiability

- [ ] Every task has a run command with expected output, not a description of testing.
- [ ] Expected failure messages are specific enough to distinguish "failed correctly" from "failed for an unrelated reason".
- [ ] The test command in the plan header matches what the repo actually uses. Check the package manifest or CI config, don't assume.
- [ ] Each task ends at a commit.

## Sizing

- [ ] Steps are single actions of roughly 2–5 minutes. Any step containing "and" is probably two steps.
- [ ] Tasks are reviewer-sized: could a reviewer accept task N and reject task N+1 independently?
- [ ] No task requires reading more than a couple of files to understand.
- [ ] If there are more than four tasks, the plan is split into an index plus task files.

## The stranger test

The one that matters most: **pick the most complex task and read only that file, plus the plan index.** Could you execute it without asking a question or opening the spec?

If you'd have to guess at a name, a location, a format, or an intent — that's a defect. Note exactly what you'd have had to guess. Fix by adding the missing fact to the task, not by adding a pointer to another document.
