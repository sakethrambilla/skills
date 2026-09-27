# skills

Agent skills that work in Claude Code, Codex, and Cursor.

## Install

```bash
git clone https://github.com/sakethrambilla/skills.git ~/skills
~/skills/install.sh
```

`install.sh` symlinks each skill into:

| Directory | Read by |
|---|---|
| `~/.claude/skills` | Claude Code |
| `~/.agents/skills` | Codex, Cursor |

Because the skills are symlinks, `git pull` updates them in every tool. If a real directory with the same name already exists, the script skips it. Remove that directory and run the script again.

### Cursor

Cursor also reads `~/.claude/skills`, so each skill loads twice. To load each skill once, turn off **Cursor Settings → Agents → Third-Party Imports**. This setting also stops Cursor from importing Claude hooks and plugins.

## Skills

| Skill | Invocation | What it does |
|---|---|---|
| `bro` | Manual | Restates the last message in plain language, with no jargon. |
| `wait-what` | Manual | Pitches the last message again when it did not land. |
| `teach` | Manual | Explains a body of work plainly. Uses the `how` and `why` skills, which this repo does not include. |
| `unslop` | Manual | Removes AI tells from writing. |
| `technical-writing` | Manual | Applies a layered standard: Diátaxis, Google developer style, STE, and Global English. |
| `handoff` | Manual | Writes a handoff document so another agent can continue the work. |
| `grilling` | Auto | Asks hard questions to stress-test a plan, decision, or idea. |
| `writing-implementation-plans` | Auto | Writes a spec and a file-by-file plan. Each task has its own verification command. |
| `executing-plans` | Auto | Runs a plan task by task and tracks state in `progress.md`. |

**Manual** skills run only when you call them:

| Tool | How to call a skill |
|---|---|
| Claude Code | `/bro` |
| Cursor | Type `/`, then search for the skill |
| Codex | `$bro` |

**Auto** skills can also start by themselves when a request matches them.

## Add a skill

1. Create `<name>/SKILL.md` with `name` and `description` in the frontmatter.
2. To make the skill manual-only, add both of these:
   - `disable-model-invocation: true` in the frontmatter. Claude Code and Cursor use this setting.
   - `<name>/agents/openai.yaml` with `allow_implicit_invocation: false`. Codex uses this file.

     ```yaml
     policy:
       allow_implicit_invocation: false
     ```

3. Run `./install.sh`.
