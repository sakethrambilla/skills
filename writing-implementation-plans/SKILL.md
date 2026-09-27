---
name: writing-implementation-plans
description: Turns a feature request, ticket, bug, or rough idea into a reviewed spec plus a file-by-file implementation plan where every task carries its own verification command. Use whenever the user asks for a plan, plan.md, implementation plan, design doc, task breakdown, or asks "how should I build X" or "how would you approach this" — and use it proactively before a multi-file change whose approach is not already settled.
---

# Writing implementation plans

Plans fail in three ways: the goal was never pinned down, the plan is too vague for the implementer to act without guessing, or the plan is too large to survive the context window during execution. Every rule below exists to close one of those three.

Produce **two artifacts, in order**:

- **Spec** — what and why. Written for a human reviewer. Contains no file paths.
- **Plan** — how. Written for an implementer with zero context. Contains almost nothing but file paths.

Never merge them. In a merged document, scope questions hide behind implementation detail and get approved by accident.

## When to skip this

Skip planning only if the finished diff can be described in one sentence. "Bump the timeout to 30s" needs no plan. "Add rate limiting" does — the sentence hides at least four decisions.

If the request spans multiple independent subsystems, say so and split it into one plan per subsystem. Each plan must produce working, testable software on its own. A plan that only makes sense once a sibling plan also lands is too big.

## Phase 0 — Scope gate

Resolve ambiguity before writing anything. Ask the user the questions in `references/scoping-questions.md`, in one batch, and wait for answers.

Do not skip this because the request seems clear. "This one is simple enough to just start" is the exact thought that produces the wrong feature. If the user says they don't know the answer to something, that is itself a finding — record it in the spec's Open Questions and note what you assumed.

## Phase 1 — Spec

Write the spec to `docs/plans/YYYY-MM-DD-<slug>/spec.md` using the structure in `references/spec-template.md`.

Two things matter more than the rest:

**Acceptance criteria must be observable.** "Login works" is untestable. "When a user submits invalid credentials three times within 60 seconds, the system returns 429 and does not increment the attempt counter further" is testable and can be turned directly into a test case later. Write each criterion as a condition and an observable response.

**Out of scope must be explicit.** An empty out-of-scope section means you haven't thought about boundaries yet. This section is what stops the implementer from helpfully refactoring three neighbouring modules.

Present the spec and get approval before continuing. Do not write the plan in the same turn as the spec.

## Phase 2 — Explore, read-only

Before planning, read the code. Find the files that will change, the tests that cover them, the existing patterns for this kind of work, and the test command the repo actually uses. Do not edit anything in this phase.

The plan's quality is capped by how much of the real codebase you looked at. A plan written from the spec alone will invent function names.

## Phase 3 — File map

Before writing a single task, list every file that will be created or modified and what each is responsible for. This is where decomposition gets decided; tasks are just a schedule laid over this map.

Heuristics, in priority order:

1. **Follow existing patterns.** In an existing codebase, match how neighbouring code is organized unless a file has grown unwieldy.
2. **Locality.** Files that change together live together. Split by responsibility, not by technical layer.
3. **Focus.** Prefer several small files with clear interfaces over one that does too much.

## Phase 4 — Tasks

Use the template in `references/plan-template.md`.

**Task boundaries.** A task is the smallest unit that carries its own test cycle and is worth a reviewer's gate. Draw the line where a reviewer could reject one task while approving its neighbour. Fold setup, config, scaffolding, and doc updates into whichever task's deliverable needs them, rather than making them tasks of their own — a standalone "set up config" task can't be independently verified.

**Step size.** Each step inside a task is one concrete action of roughly 2–5 minutes. "Add a test and make it pass" is five steps: write the failing test, run it and confirm the failure, write the minimal implementation, run it and confirm the pass, commit.

**Write for a stranger.** Assume the implementer is a strong engineer who has never seen this codebase and has poor judgment about when to improvise. Give exact paths, exact signatures, exact commands. Anything you leave to their judgment, they will decide differently than you would.

**Every task ends with a verification the implementer can run.** Not "test it" — the literal command and the literal expected output. This is the single highest-leverage line in the plan, because it is what lets an agent tell success from a plausible-looking failure. If a task's outcome can't be checked by a command, a screenshot comparison, or a lint/type check that returns pass or fail, redraw the task boundary until it can.

**No placeholders.** "TBD", "TODO", "add validation as needed", "handle errors appropriately" are plan failures, not plan items. If you don't know, that's an open question for the user, not a gap to paper over.

## Phase 5 — Review with fresh eyes

Before handing off, review the plan against `references/review-checklist.md`.

If subagents are available, dispatch one with the checklist, the plan path, and the spec path, and have it report gaps — a reviewer that didn't write the plan catches things the author is blind to. Otherwise re-read the plan yourself, top to bottom, against the checklist, and specifically ask: could someone who has never seen this repo execute Task 3 without asking a question?

Fix what the review finds before showing the plan to the user.

## Phase 6 — Size and hand off

Sizing rule: **one plan.md if there are four tasks or fewer.** Beyond that, split it:

```
docs/plans/YYYY-MM-DD-<slug>/
├── spec.md
├── plan.md          # goal, constraints, file map, task index — short
├── tasks/
│   ├── 01-<name>.md
│   └── 02-<name>.md
└── progress.md      # created at execution time, not now
```

A single large plan file forces the whole thing into context on every read and forces a re-read after every compaction. With the split layout, an executing agent reads a short index and one task file at a time.

Keep `plan.md` and `tasks/` stable during execution — they are intent. Mutable state belongs in `progress.md`. Mixing the two is how plans rot.

Then present the two execution options and let the user choose:

1. **Fresh agent per task** (recommended when subagents exist) — each task goes to a subagent with a clean context, reviewed between tasks. Keeps the coordinating context lean.
2. **Inline** — execute in this session, pausing for review at task boundaries.

Either way, execution follows the `executing-plans` skill.
