# Plan and task templates

## plan.md

Keep this short — it is the index an executing agent re-reads after every context compaction. Everything task-specific lives in the task files.

```markdown
# <Feature> — implementation plan

> Execute with the `executing-plans` skill, one task at a time.
> Track state in progress.md, never in this file.

**Spec:** ./spec.md
**Branch / worktree:** <name>
**Test command:** <the exact command, e.g. `pnpm test --filter api`>
**Lint / typecheck:** <exact command>

## Approach
Three to five sentences on the shape of the solution and why this shape
over the obvious alternative. This is the part a reviewer argues with.

## Global constraints
Rules that apply to every task. Pulled from the spec, plus anything
discovered while reading the code.
- <e.g. no new runtime dependencies>
- <e.g. all new endpoints go through the existing auth middleware>

## File map
| File | Create/Modify | Responsibility |
|---|---|---|
| src/auth/rateLimit.ts | Create | Token-bucket state and the check function |
| src/auth/login.ts:88-140 | Modify | Call the limiter before credential check |
| src/auth/__tests__/rateLimit.test.ts | Create | Unit tests for the limiter |

## Tasks
1. [tasks/01-rate-limiter-core.md](tasks/01-rate-limiter-core.md) — pure limiter, no wiring
2. [tasks/02-wire-into-login.md](tasks/02-wire-into-login.md) — call site + integration test
3. [tasks/03-metrics.md](tasks/03-metrics.md) — counter emission

## Risks
Anything likely to go sideways, and what to do about it. If there are
none, say so — an empty section reads as an oversight.
```

With four tasks or fewer, inline the task bodies under `## Tasks` instead of splitting into files.

## Task file

```markdown
# Task 2: Wire the limiter into login

**Depends on:** Task 1
**Files:**
- Modify: `src/auth/login.ts:88-140`
- Create: `src/auth/__tests__/login.rateLimit.test.ts`

**Interfaces:**
- Consumes: `checkLimit(key: string, now: number): { allowed: boolean; retryAfterMs: number }`
- Produces: HTTP 429 with a `Retry-After` header, in seconds

## Steps

- [ ] 1. Write the failing test in `login.rateLimit.test.ts`: four
      submissions inside 60s, assert the fourth returns 429 and that
      `verifyCredentials` was not called on it.

- [ ] 2. Run `pnpm test login.rateLimit`.
      Expect: FAIL — `Expected 429, received 401`.
      If it fails differently, stop and reconcile before continuing.

- [ ] 3. In `login.ts`, call `checkLimit` before `verifyCredentials`.
      On `allowed: false`, return 429 with `Retry-After` set to
      `Math.ceil(retryAfterMs / 1000)`.

- [ ] 4. Run `pnpm test login.rateLimit`. Expect: PASS, 4 assertions.

- [ ] 5. Run the full suite: `pnpm test`. Expect: no new failures.

- [ ] 6. `git add src/auth/login.ts src/auth/__tests__/login.rateLimit.test.ts`
      `git commit -m "feat(auth): return 429 when login rate limit exceeded"`

## Done when
The fourth rapid login attempt returns 429 with a Retry-After header and
does not touch the credential store. Full suite green.
```

## What makes this work

**Step 2 is the load-bearing step.** Running the test *before* the implementation exists and confirming it fails for the expected reason is what proves the test is actually wired to the behaviour. A test that passes before the code is written tests nothing, and this is the single most common silent failure in agent-written test suites.

**Exact expected output, not "should fail".** `Expected 429, received 401` tells the implementer whether they're on the right track. "It should fail" is satisfied by a syntax error.

**Every task ends at a commit.** Task boundaries and commit boundaries should be the same thing. That is what makes a task revertable and reviewable in isolation.

**Interfaces are declared before implementation.** Naming what a task consumes and produces is what lets tasks 2 and 3 be written before task 1 exists — and what surfaces a mismatch at planning time rather than at hour three of execution.
