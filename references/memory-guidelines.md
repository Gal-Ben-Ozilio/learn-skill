# Memory Guidelines

## Good Learnings by Sub-target

### `~/.claude/CLAUDE.md` — Global index (1-liners only)
- "Package manager: bun — see rules/workflow.md"
- "Commit only when explicitly asked — see rules/workflow.md"
- "TypeScript strict mode in all projects — see rules/code-style.md"

### `~/.claude/rules/<topic>.md` — Global behavioral rules
Things that shape how Claude works across every project:
- "Never suggest npm or yarn — always bun. Mention bun equivalents when npm scripts exist."
- "Only create git commits when explicitly asked. Never commit proactively after finishing a task."
- "Prefers TypeScript strict mode: noUncheckedIndexedAccess, strictNullChecks, exactOptionalPropertyTypes."
- "Uses tmux — avoid commands that assume a full-screen terminal."
- "Code comments only for non-obvious logic — don't narrate what the code does."
- "Keep responses concise — lead with the answer, skip filler preamble."

### `~/.claude/skills/<name>/` — Global reusable workflows
Propose when a multi-step workflow was repeated 2+ times in the session:
- A 4-step deploy sequence (pull → build → tag → push) done twice → `/deploy` skill
- A recurring PR prep checklist → `/pr-prep` skill
- Repeated API testing sequence → `/api-test` skill

### `~/.claude/agents/<name>.md` — Global specialized subagents
Propose when a specialized domain emerged that benefits from dedicated tools/model:
- Security review tasks that need restricted tools → `security-reviewer` agent
- Database query work → `db-analyst` agent
- Documentation generation with specific constraints → `doc-writer` agent

### `.claude/CLAUDE.md` — Project shared instructions (committed)
Short conventions the whole team should know:
- "Monorepo: apps/ for deployable services, packages/ for shared libs"
- "Custom ESLint rule no-direct-db-calls is enforced — don't suggest disabling it"
- "Database migrations must be backwards-compatible (rolling deploys)"
- "Auth tokens stored in httpOnly cookies, not localStorage"

### `.claude/rules/<topic>.md` — Project rules (committed, optionally path-scoped)
Substantive behavioral rules for this codebase:
- "All API handlers must validate input with zod before touching business logic"
- "Component tests use Testing Library — never Enzyme or direct DOM manipulation"
- (path-scoped) "When editing src/payments/**, check PCI notes in SECURITY.md before suggesting changes"

### `.claude/CLAUDE.local.md` — Project personal notes (gitignored)
Personal notes that shouldn't go in the repo:
- "Local dev requires VPN to reach staging DB (vpn connect corp)"
- "The payments service is flaky locally — always verify on staging before marking done"
- "Ask before touching legacy/ — it's being actively migrated"
- "My local API port is 3001 (README says 3000 — outdated)"

---

## Bad Learnings (don't save these)

- "Fixed bug in UserService.ts line 42" — too session-specific
- "Ran npm install to fix dependency issue" — temporary debugging step
- "The API returned a 500 error" — transient state
- "User asked about React hooks" — too generic, Claude already knows this
- "Created utils.ts" — file changes are tracked by git
- "Always check if tests pass" — obvious, not user/project-specific

---

## When to Use `rules/` vs `CLAUDE.md`

| Use `rules/<topic>.md` | Use `CLAUDE.md` index entry |
|---|---|
| More than 2 lines of detail | Single-line fact or pointer |
| Behavioral instruction (how to act) | Reference fact or pointer to a rules file |
| "Always", "Never", "When", "Before/After" | A quick named fact ("Package manager: bun") |
| Applies to a category of situations | Always-relevant shorthand |
| Multiple related rules on same topic | One-off preference |

---

## Deduplication Rules

1. Read the target file before writing — never skip this step
2. If an existing entry covers the same topic, update it; don't add a duplicate
3. If the new learning contradicts an existing one, replace the old entry
4. Merge related entries (e.g., two testing preferences → one combined rule)
5. If a CLAUDE.md entry has grown to >3 lines, move detail to a rules file and replace with a pointer

---

## File Format Conventions

### `~/.claude/CLAUDE.md` (global index — keep lean)
```markdown
# User Preferences

## Tools
- Package manager: bun — see [rules/workflow.md](rules/workflow.md)

## Workflow
- Commit only when explicitly asked — see [rules/workflow.md](rules/workflow.md)

## Code Style
- TypeScript strict mode — see [rules/code-style.md](rules/code-style.md)
```

### `~/.claude/rules/workflow.md` (global rules file)
```markdown
# Workflow Rules

## Commits
- Only create git commits when explicitly asked — never commit proactively
- Before pushing to remote, always confirm with the user
- Prefer editing existing files over creating new ones

## Package Management
- Package manager: bun (never npm or yarn)
- When a project uses npm scripts, mention the bun equivalent

## Terminal
- User runs tmux — avoid commands that assume a full-screen terminal
```

### `.claude/rules/testing.md` (project rule — no path scope)
```markdown
# Testing Rules

- Use vitest for all unit and integration tests — never jest or mocha
- Component tests use Testing Library — no Enzyme or direct DOM queries
- Test files alongside source files as `<name>.test.ts`
- Always mock external HTTP calls — never hit real APIs in tests
```

### `.claude/rules/payments.md` (project rule — path-scoped)
```markdown
---
paths:
  - src/payments/**
  - packages/billing/**
---

# Payments Rules

- Check SECURITY.md PCI notes before suggesting any change to payment flows
- Never log card numbers, CVVs, or full PANs — mask after first 6 digits
- All payment amounts must be handled as integers (cents), never floats
```

### New agent stub — `~/.claude/agents/<name>.md`
```markdown
---
name: security-reviewer
description: Specialized agent for security review tasks. Use when reviewing code for vulnerabilities, checking authentication flows, or auditing sensitive operations. Has read-only tool access to prevent accidental changes during review.
model: claude-opus-4-6
tools: Read, Grep, Glob, WebSearch
---

You are a security-focused code reviewer. Your role is to identify vulnerabilities, insecure patterns, and compliance issues. You do not make changes — you report findings with severity levels and recommended fixes.

Focus on: OWASP Top 10, authentication/authorization flaws, injection vulnerabilities, sensitive data exposure, and insecure dependencies.
```
