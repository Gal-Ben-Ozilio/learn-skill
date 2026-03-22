# Memory Guidelines

## Good Learnings (save these)

### Project Memory Examples
- "Monorepo with apps/ for services and packages/ for shared libs"
- "Uses custom ESLint rule X — don't suggest disabling it"
- "Database migrations must be backwards-compatible (rolling deploys)"
- "Component tests use Testing Library, not Enzyme"
- "Auth tokens are stored in httpOnly cookies, not localStorage"

### User Memory Examples
- "Prefers TypeScript strict mode in all projects"
- "Wants git commits only when explicitly asked"
- "Uses tmux — terminal commands should account for that"
- "Prefers functional components over class components"
- "Likes detailed code comments for complex algorithms only"

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

### CLAUDE.md Structure
```markdown
# Project Conventions

## Code Style
- [conventions here]

## Architecture
- [decisions here]

## Testing
- [approaches here]

## Workflow
- [preferences here]
```

### MEMORY.md Structure
```markdown
# User Preferences

## Workflow
- [cross-project preferences]
- See [workflow.md](workflow.md) for details

## Communication Style
- [how the user likes to interact]

## Tools
- [preferred tools and configurations]
```
