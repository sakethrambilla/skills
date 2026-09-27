# Spec template

Write to `docs/plans/YYYY-MM-DD-<slug>/spec.md`. Target one page. A spec longer than two pages is usually two specs.

No file paths, no function names, no library choices — those belong in the plan. If a technical detail is genuinely load-bearing for the decision (a hard dependency, a protocol that's fixed), put it under Constraints and say why it's fixed.

```markdown
# <Feature name>

## Problem
What is wrong today, for whom, and how often. Two or three sentences.
Include the observation that prompted this, not just the abstraction.

## Goal
One sentence. What is true after this ships that isn't true now.

## Non-goals
Explicit list. Each line is something a reasonable person might assume is
included and isn't. An empty section means this wasn't thought about.

## Behaviour
The system as the user experiences it. Prose or a short walkthrough.
Cover the happy path first, then what happens when things go wrong.

## Acceptance criteria
Numbered. Each one a condition and an observable response, phrased so it
could become a test without further interpretation.

1. When <condition or event>, the system <observable response>.
2. When <error condition>, the system <observable response> and <what does
   not happen>.

## Constraints
Performance budgets, compatibility requirements, security or compliance
rules, deadlines, dependencies that cannot change. Anything that rules
out an otherwise reasonable approach.

## Open questions
Things the user could not answer. For each, state the assumption being
made so the reader can object to it.

- <question> — proceeding on the assumption that <assumption>.
```

## On acceptance criteria

The condition/response phrasing is borrowed from EARS notation (Easy Approach to Requirements Syntax), which several spec-driven frameworks standardize on. You do not need the full notation, but the discipline it enforces is worth keeping: every criterion names a trigger and a response, and neither is left implicit.

**Weak:** Passwords are validated.
**Better:** When a user submits a password shorter than 12 characters, the form displays "Password must be at least 12 characters" beside the field and does not submit.

The second version tells you what to test, where the message goes, and that no request is made. The first tells you nothing.

Cover at least one failure case per feature. Specs that only describe the happy path produce implementations that only handle the happy path.
