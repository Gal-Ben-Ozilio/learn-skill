---
name: learn
description: End-of-session learning extraction and memory management. Use this skill when the user wants to capture learnings from the current conversation, when they say "/learn", "save what we learned", "remember this for next time", or at the end of a productive session. Extracts patterns, preferences, decisions, repeated workflows, and emerging specializations — then routes each to the correct memory target (rules, CLAUDE.md, skills, or agents) after interactive confirmation.
---

# Learn

Extract and persist learnings from the current conversation into the right target file.

## Memory Architecture

Two primary targets — **global** and **project** — each with sub-targets:

### Global (`~/.claude/`) — applies across all projects

| Sub-target | Path | Purpose |
|---|---|---|
| Index | `~/.claude/CLAUDE.md` | Short pointers only. Always loaded, truncates at ~200 lines — keep lean. |
| Rules | `~/.claude/rules/<topic>.md` | Always-on behavioral rules. Prefer this over bloating CLAUDE.md. |
| Skills | `~/.claude/skills/<name>/SKILL.md` | Reusable personal workflows invokable as `/name`. |
| Agents | `~/.claude/agents/<name>.md` | Personal specialized subagents with dedicated tools/model. |

### Project (`.claude/`) — applies to this codebase only

| Sub-target | Path | Committed? | Purpose |
|---|---|---|---|
| Shared instructions | `.claude/CLAUDE.md` | Yes | Team-visible conventions and architecture decisions. |
| Personal notes | `.claude/CLAUDE.local.md` | No (gitignored) | Personal project notes, never shared with team. |
| Project rules | `.claude/rules/<topic>.md` | Yes (usually) | Modular rules, optionally path-scoped to specific files. |
| Project skills | `.claude/skills/<name>/SKILL.md` | Yes | Project-specific reusable workflows. |
| Project agents | `.claude/agents/<name>.md` | Yes | Project-specific subagents. |

> Do NOT write to `~/.claude/projects/<hash>/memory/MEMORY.md` — Claude manages that automatically.

---

## Routing Decision Logic

Use this tree to determine where each learning belongs:

```
Does this apply across all projects (personal preference, tool choice, workflow)?
  YES → Global
    Is it a 1-liner fact or frequently-needed pointer?
      YES → ~/.claude/CLAUDE.md (index entry only)
      NO, it's a behavioral rule ("always/never/when...")?
        YES → ~/.claude/rules/<topic>.md
              + add a pointer line to ~/.claude/CLAUDE.md if not already indexed
      NO, it's a repeated multi-step workflow (seen 2+ times)?
        YES → Propose new skill → ~/.claude/skills/<name>/ (use skill-creator)
      NO, it's a specialized task needing its own tools or model?
        YES → Propose new agent → ~/.claude/agents/<name>.md

  NO → Project-specific
    Should the whole team know this?
      YES → Is it a substantive rule (>2 lines, behavioral)?
              YES → .claude/rules/<topic>.md
                    (add paths: frontmatter if only relevant to specific file patterns)
              NO  → .claude/CLAUDE.md
            Is it a repeated project-specific workflow?
              YES → Propose new skill → .claude/skills/<name>/
            Is it a specialized project subagent pattern?
              YES → Propose new agent → .claude/agents/<name>.md
      NO  → .claude/CLAUDE.local.md (personal, gitignored)
```

**Path-scope trigger:** if a rule only applies when editing specific file patterns (e.g., "when in src/payments/\*\*..."), add `paths:` YAML frontmatter to the rules file.

---

## Workflow

1. **Analyze the conversation** for reusable knowledge
   - Scan for patterns, decisions, corrections, preferences, workflow insights
   - Flag: repeated multi-step workflows (skill candidate), specialized domain patterns (agent candidate)
   - Ignore session-specific details (current task state, one-off fixes, transient errors)
   - See `references/memory-guidelines.md` for examples of good vs bad learnings

2. **Route each learning** using the decision logic above

3. **Check for duplicates** by reading existing files before writing
   - Read `~/.claude/CLAUDE.md` and any `~/.claude/rules/` files relevant to the findings
   - Read `.claude/CLAUDE.md`, `.claude/CLAUDE.local.md`, and relevant `.claude/rules/` files
   - Skip or merge with existing entries; update contradictions rather than duplicating

4. **Present proposals interactively**
   - Group by sub-target, show exact file path and reason for each learning
   - Use AskUserQuestion to let the user approve, edit, or reject each group
   - Example format:

   ```
   ## Global

   → ~/.claude/CLAUDE.md (index)
   1. "Package manager: bun — see rules/workflow.md"

   → ~/.claude/rules/workflow.md (new file)
   2. "Only create git commits when explicitly asked — never commit proactively"
   3. "Before pushing to remote, always confirm with the user first"

   → New skill: /deploy (→ ~/.claude/skills/deploy/)
   4. Repeated workflow detected: git pull → build → tag → push. Propose creating /deploy skill?

   ## Project

   → .claude/CLAUDE.md (team-shared)
   1. "API routes follow /api/v1/{resource} pattern"

   → .claude/rules/testing.md (team-shared rule)
   2. "Use vitest — never jest or mocha"

   → .claude/rules/frontend.md (path-scoped: src/frontend/**)
   3. "Use design system tokens from tokens.ts — no hardcoded colors"

   → .claude/CLAUDE.local.md (personal, gitignored)
   4. "Local dev requires VPN to reach staging DB"
   ```

5. **Write approved learnings**
   - `~/.claude/CLAUDE.md` — add/update a short pointer line only, no detail
   - `~/.claude/rules/<topic>.md` — full rule content; create file if needed (see format in `references/memory-guidelines.md`)
   - **New skill** — use the `skill-creator` (bundled in `dependencies/skill-creator/`) to scaffold properly: run `init_skill.py`, write the SKILL.md, package it
   - **New agent** — write a minimal `.md` with YAML frontmatter + brief system prompt (see format in `references/memory-guidelines.md`)
   - `.claude/CLAUDE.md` — append under the relevant section or create with structure
   - `.claude/CLAUDE.local.md` — personal notes, no enforced structure, keep readable
   - `.claude/rules/<topic>.md` — write with optional YAML `paths:` frontmatter for path scoping
   - Use Edit for existing files, Write for new ones

---

## Bundled Dependency: skill-creator

When creating a new skill is approved, use the skill-creator bundled at `dependencies/skill-creator/`:

```bash
python3 dependencies/skill-creator/scripts/init_skill.py <skill-name> --path <target-dir>
```

Follow the full skill-creator workflow: init → edit SKILL.md → package. See `dependencies/skill-creator/SKILL.md` for the complete guide.

---

## Guidelines

- **Be selective** — only save knowledge that will help in future sessions
- **Keep `~/.claude/CLAUDE.md` lean** — index entries only, max 1-2 lines each; truncates at ~200 lines
- **Prefer `rules/` over CLAUDE.md** — if something needs more than 2 lines, it's a rule
- **Prefer updates over additions** — update existing entries rather than duplicating
- **Never save secrets** — no API keys, tokens, passwords, or sensitive data
- **Don't save obvious things** — save what's specific to this user/project, not general coding knowledge
- **Corrections are high-priority** — if the user corrected Claude during the session, always capture that
- **Distinguish personal from team** — when unsure about committed vs gitignored, ask the user
- **Don't write to auto-memory** — `~/.claude/projects/<hash>/memory/MEMORY.md` is managed by Claude automatically
