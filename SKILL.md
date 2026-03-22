---
name: learn
description: End-of-session learning extraction and memory management. Use this skill when the user wants to capture learnings from the current conversation, when they say "/learn", "save what we learned", "remember this for next time", or at the end of a productive session. Extracts patterns, preferences, and decisions and saves them to the appropriate memory layer (project or user level) after interactive confirmation.
---

# Learn

Extract and persist learnings from the current conversation into the appropriate memory layer.

## Memory Layers

**Project memory** — project-specific knowledge saved to the project's `CLAUDE.md` file:
- Coding conventions and patterns specific to this codebase
- Architecture decisions and rationale
- Tech stack specifics (versions, configurations, quirks)
- Testing approaches and CI/CD patterns
- File structure and naming conventions

**User memory** — cross-project personal preferences saved to auto-memory files at `~/.claude/projects/<project-path>/memory/`:
- `MEMORY.md` — concise index (keep under 200 lines, it's always loaded)
- Topic files (e.g., `workflow.md`, `preferences.md`) — detailed notes linked from MEMORY.md

## Workflow

1. **Analyze the conversation** for reusable knowledge
   - Scan for patterns, decisions, corrections, preferences, and workflow insights
   - Ignore session-specific details (current task state, temporary debugging steps)
   - See `references/memory-guidelines.md` for what qualifies as a good learning

2. **Categorize each learning** as project or user memory
   - If it only applies to this specific codebase → project memory
   - If it applies across projects (personal preference, tool usage, workflow) → user memory

3. **Check for duplicates** by reading existing memory files
   - Read the project's `CLAUDE.md` if it exists
   - Read `MEMORY.md` and any relevant topic files from auto-memory
   - Skip or merge with existing entries rather than duplicating

4. **Present proposals interactively**
   - Group learnings by memory layer
   - For each learning, show: the learning, where it will be saved, and why
   - Use AskUserQuestion to let the user approve, edit, or reject each group
   - Example format:

   ```
   ## Project Memory (→ CLAUDE.md)
   1. "Use vitest for testing, not jest" — observed from test configuration
   2. "API routes follow /api/v1/{resource} pattern" — observed from route files

   ## User Memory (→ memory/MEMORY.md)
   1. "Prefers concise PR descriptions with bullet points" — observed from PR workflow
   2. "Uses bun as package manager across projects" — stated preference
   ```

5. **Write approved learnings** to the appropriate files
   - For project CLAUDE.md: append to existing file or create with a clear structure
   - For MEMORY.md: keep concise, link to topic files for details
   - For topic files: create or update as needed (e.g., `preferences.md`, `patterns.md`)
   - Use Edit for existing files, Write for new ones

## Guidelines

- **Be selective** — only save knowledge that will actually help in future sessions
- **Be concise** — each learning should be 1-2 lines max
- **Prefer updates over additions** — if an existing memory covers a similar topic, update it
- **Never save secrets** — no API keys, tokens, passwords, or sensitive data
- **Don't save obvious things** — Claude already knows how to code; save what's specific to this user/project
- **Corrections are high-priority** — if the user corrected Claude during the session, always capture that
