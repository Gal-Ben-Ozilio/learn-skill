# /learn — Claude Code Learning Skill

A skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that extracts and persists learnings from conversations into structured memory.

## What it does

When you run `/learn` at the end of a session, it:

1. **Analyzes** the conversation for reusable patterns, decisions, and preferences
2. **Categorizes** each learning into the appropriate memory layer:
   - **Project memory** (`CLAUDE.md`) — codebase-specific conventions, architecture decisions, testing patterns
   - **User memory** (`~/.claude/.../memory/`) — personal preferences and cross-project workflows
3. **Checks** existing memory files to avoid duplicates
4. **Presents** grouped proposals interactively for you to approve, edit, or reject
5. **Writes** only approved learnings to the right files

## Installation

### Option 1: Install the `.skill` file

Download the latest `.skill` file from [Releases](../../releases) and install it in Claude Code:

```
/install-skill path/to/learn.skill
```

### Option 2: Use directly from the repo

Add the skill path to your Claude Code configuration, or symlink the `SKILL.md` into your skills directory.

## File Structure

```
learn-skill/
├── SKILL.md                       # Core skill instructions
├── references/
│   └── memory-guidelines.md       # Examples, dedup rules, file format conventions
└── README.md
```

## Contributing

Contributions welcome! If you have ideas for improving the learning extraction or memory management, open an issue or PR.

## License

MIT
