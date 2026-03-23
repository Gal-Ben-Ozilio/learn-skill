# Memory Guidelines

## Good Learnings (save these)

### Global User Memory (`~/.claude/CLAUDE.md` + topic files)
Things that are true regardless of which project you're in:
- "Uses bun as package manager — never suggest npm or yarn"
- "Commits only when explicitly asked"
- "Prefers TypeScript strict mode"
- "Uses tmux — terminal commands should account for split panes"
- "Prefers functional components over class components"
- "Likes code comments only for non-obvious logic"

### Project Memory (`CLAUDE.md` in repo root)
Things specific to this codebase that the whole team should know:
- "Monorepo with apps/ for services and packages/ for shared libs"
- "Uses custom ESLint rule X — don't suggest disabling it"
- "Database migrations must be backwards-compatible (rolling deploys)"
- "Component tests use Testing Library, not Enzyme"
- "Auth tokens stored in httpOnly cookies, not localStorage"

### Personal Project Memory (`~/.claude/projects/.../memory/`)
Personal notes about this project that shouldn't go in the repo:
- "Local dev requires VPN to reach staging DB"
- "The payments service is flaky locally — always test on staging"
- "Ask before touching anything in the legacy/ folder — it's being migrated"

## Bad Learnings (don't save these)

- "Fixed bug in UserService.ts line 42" — too session-specific
- "Ran npm install to fix dependency issue" — temporary debugging step
- "The API returned a 500 error" — transient state
- "User asked about React hooks" — too generic, Claude already knows hooks
- "Created a new file called utils.ts" — file changes are tracked by git

## Deduplication Rules

1. Before writing, always read the target file first
2. If an existing entry covers the same topic, update it instead of adding a new one
3. If the new learning contradicts an existing one, replace the old entry
4. Merge related entries (e.g., two entries about testing preferences → one combined entry)

## File Format Conventions

### `~/.claude/CLAUDE.md` (global index — keep lean)
```markdown
# User Preferences

Short pointers only — details live in topic files.

## Workflow
- Commit only when explicitly asked
- See [preferences.md](preferences.md) for full workflow preferences

## Code Style
- TypeScript strict mode in all projects
- See [patterns.md](patterns.md) for detailed patterns

## Tools
- Package manager: bun
- See [preferences.md](preferences.md) for full tool preferences
```

### `~/.claude/preferences.md` (global topic file example)
```markdown
# Preferences

## Workflow
- Only create git commits when explicitly asked
- Prefer editing existing files over creating new ones
- Ask before pushing to remote

## Tools
- Package manager: bun (never npm or yarn)
- Uses tmux for terminal sessions

## Communication
- Keep responses concise
- Skip filler phrases and preamble
```

### Project `CLAUDE.md`
```markdown
# Project Conventions

## Architecture
- [decisions here]

## Code Style
- [conventions here]

## Testing
- [approaches here]
```

### Personal project `MEMORY.md`
```markdown
# Notes on <project-name>

## Setup
- [local setup quirks]

## Watch out for
- [personal reminders]

## See also
- [topic-file.md](topic-file.md) for details
```
