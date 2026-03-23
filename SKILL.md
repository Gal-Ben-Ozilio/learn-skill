---
name: learn
description: End-of-session learning extraction and memory management. Use this skill when the user wants to capture learnings from the current conversation, when they say "/learn", "save what we learned", "remember this for next time", or at the end of a productive session. Extracts patterns, preferences, and decisions and saves them to the appropriate memory layer (global, project, or personal project-scoped) after interactive confirmation.
---

# Learn

Extract and persist learnings from the current conversation into the appropriate memory layer.

## Memory Layers

There are three layers, from broadest to narrowest scope:

**1. Global user memory** — applies across all projects, all sessions. Saved to `~/.claude/CLAUDE.md`.
- Keep this file lean — it's loaded in every session and truncates after ~200 lines
- Use it as an index only: short entries that point to topic files in `~/.claude/`
- Topic files (e.g., `~/.claude/preferences.md`, `~/.claude/patterns.md`) hold the details
- Claude loads topic files on demand when relevant to the current task
- Examples: package manager preference, commit workflow, communication style, general code style

**2. Project memory** — applies to one specific codebase. Saved to `CLAUDE.md` in the project root.
- Committed to the repo — visible to the whole team
- Examples: architecture decisions, tech stack conventions, testing patterns, file structure rules

**3. Personal project memory** — personal notes about a specific project, never committed. Saved to `~/.claude/projects/<project-path>/memory/`:
- `MEMORY.md` — concise index (keep under 200 lines, always loaded for this project)
- Topic files linked from MEMORY.md for details
- Examples: personal reminders about the codebase, local setup quirks, notes you don't want in the repo

## Workflow

1. **Analyze the conversation** for reusable knowledge
   - Scan for patterns, decisions, corrections, preferences, and workflow insights
   - Ignore session-specific details (current task state, temporary debugging steps)
   - See `references/memory-guidelines.md` for what qualifies as a good learning

2. **Categorize each learning** into the right layer:
   - Applies to all projects + is a personal preference → **global user memory**
   - Applies to this codebase + should be shared with the team → **project memory**
   - Applies to this codebase + is personal/local only → **personal project memory**

3. **Check for duplicates** by reading existing memory files
   - Read `~/.claude/CLAUDE.md` and any linked topic files relevant to the findings
   - Read the project's `CLAUDE.md` if it exists
   - Read `~/.claude/projects/.../memory/MEMORY.md` and relevant topic files
   - Skip or merge with existing entries rather than duplicating

4. **Present proposals interactively**
   - Group learnings by memory layer
   - For each learning, show: the learning, where it will be saved, and why
   - Use AskUserQuestion to let the user approve, edit, or reject each group
   - Example format:

   ```
   ## Global Memory (→ ~/.claude/CLAUDE.md + topic files)
   1. "Uses bun as package manager" → ~/.claude/preferences.md
   2. "Commit only when explicitly asked" → ~/.claude/preferences.md

   ## Project Memory (→ CLAUDE.md)
   1. "Use vitest for testing, not jest" — observed from test configuration
   2. "API routes follow /api/v1/{resource} pattern" — observed from route files

   ## Personal Project Memory (→ ~/.claude/projects/.../memory/)
   1. "Local dev requires VPN to reach staging DB" — personal setup note
   ```

5. **Write approved learnings** to the appropriate files
   - For `~/.claude/CLAUDE.md`: add a short pointer entry + write/update the relevant topic file
   - For project `CLAUDE.md`: append under the relevant section or create with clear structure
   - For personal project `MEMORY.md`: keep concise, link to topic files for details
   - Use Edit for existing files, Write for new ones

## Guidelines

- **Be selective** — only save knowledge that will actually help in future sessions
- **Be concise** — each learning should be 1-2 lines max in index files; details go in topic files
- **Keep `~/.claude/CLAUDE.md` lean** — it's an index, not a knowledge dump; move details to topic files
- **Prefer updates over additions** — if an existing memory covers a similar topic, update it
- **Never save secrets** — no API keys, tokens, passwords, or sensitive data
- **Don't save obvious things** — Claude already knows how to code; save what's specific to this user/project
- **Corrections are high-priority** — if the user corrected Claude during the session, always capture that
