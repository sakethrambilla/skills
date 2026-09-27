# Scoping questions

Ask these in a single batch before writing the spec. Skip any the user has already clearly answered — asking a question they just answered signals you weren't listening. Adapt the wording; the point is the coverage, not the phrasing.

Ask about **the problem**, not the solution. If the user opens with a proposed solution ("add a Redis cache"), ask what they observed that made them want it. Roughly a third of the time the underlying problem has a smaller fix.

## The seven

1. **Who hits this, and how often?** Distinguishes a hot path from an edge case, which changes almost every downstream decision.

2. **What does the user see today, and what should they see instead?** Forces a concrete before/after. If the answer is abstract, the acceptance criteria will be too.

3. **What is explicitly out of scope?** Offer candidates you noticed while reading the request — "I'm assuming this doesn't cover the admin panel, correct?" People rarely volunteer boundaries but will confirm them readily.

4. **What must not break?** Existing behaviour, API contracts, data already in the database, other teams' consumers.

5. **Where does this live?** Existing module to extend, or something new? If the user doesn't know, that's for Phase 2 exploration, not for them.

6. **How will we know it works?** Existing test suite, a new test, a manual check, a metric. If nobody can name a check, the feature has no definition of done.

7. **What's the constraint that isn't obvious?** Deadline, performance budget, a dependency that can't be upgraded, a compliance rule, a migration that has to be reversible.

## Handling non-answers

- **"I don't know"** → Record it in the spec under Open Questions, state the assumption you're proceeding with, and flag it in the handoff. Don't silently pick.
- **"Just do whatever you think"** → Pick, state the pick in one sentence, and move on. Don't re-ask; the user has delegated.
- **"All of it, it all matters"** on scope → Push once: "If only one of these shipped this week, which one?" Unranked scope produces unranked tasks.

## What not to ask

Don't ask questions the codebase can answer — which test runner, what the current schema is, whether a helper already exists. Read the code in Phase 2 instead. Asking a user to describe their own repo back to you wastes the one resource planning is supposed to protect: their attention.
