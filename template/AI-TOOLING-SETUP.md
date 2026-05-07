# AI Tooling Setup

This project uses Claude Code with a shared configuration for consistent AI-assisted development.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed: `npm install -g @anthropic-ai/claude-code`
- pnpm installed: `npm install -g pnpm`
- Docker installed (required for GitHub MCP)

## Project-Scoped Tools (automatic)

The following MCP servers are configured in `.mcp.json` and activate automatically when you open this project in Claude Code:

| Server | Purpose |
|--------|---------|
| **context7** | Live, version-pinned docs for any library |
| **shadcn** | shadcn/ui component registry and search |

These require no setup — Claude Code starts them automatically.

## Personal Tools (one-time setup)

Some tools require personal credentials and are installed at the user scope. Run the installer once on your machine from the toolkit repo:

```bash
bash path/to/frontend-agent-toolkit/install.sh
```

This walks you through setting up:
- **GitHub MCP** — PR and issue management (requires GitHub PAT + Docker)
- **Figma MCP** — Design file access (requires Figma personal access token)
- **Vercel MCP** — Deployment management (requires Vercel token)

## Automatic Hooks

Claude Code runs these hooks automatically after every file edit:

- **prettier** — formats the file in place
- **eslint --fix** — auto-fixes lint issues

Both hooks run silently and never block. If a file can't be formatted, the hook exits cleanly.

**Optional: TypeScript checking**

To enable TypeScript type checking after every edit, set this in your shell:

```bash
export CLAUDE_HOOKS_TYPECHECK=1
```

This runs `pnpm tsc --noEmit` after each `.ts`/`.tsx` edit and surfaces errors in the same turn. Disabled by default — it's slow on large projects.

To disable hooks entirely for a session, set `CLAUDE_SKIP_HOOKS=1` before launching Claude Code (note: this disables all hooks, not just formatting).

## Available Skills

Claude Code automatically loads these project skills:

| Skill | Loaded when |
|-------|-------------|
| **component-patterns** | Always on — compound components, cva variants, hook extraction |
| **project-conventions** | Always on — imports, path aliases, file structure, naming |

## Available Commands

| Command | Phase | Description |
|---------|-------|-------------|
| `/plan [feature]` | 0 | Investigate codebase, write a structured plan to `docs/plans/` |
| `/execute-plan [name]` | 1 | Run a plan step-by-step with per-step verification |
| `/generate-component` | 1 | Scaffold a component with tests, types, and barrel export |
| `/cleanup [file]` | 2 | Accessibility, motion, design system, code quality |
| `/polish [file or scope]` | 3 | Pre-PR audit: SEO, performance, responsiveness, test coverage |
| `/investigate [question]` | Any | Answer a codebase question using a read-only subagent |

## Subagents

Two subagents run in isolated contexts to keep the main session lean:

| Agent | Invoked by | What it does |
|-------|-----------|--------------|
| **code-explorer** | `/plan`, `/investigate` | Read-only codebase investigation — never writes files |
| **pr-reviewer** | `/polish` | Pre-ship audit against the full polish checklist |

Delegate to `code-explorer` any time a question requires reading more than 5 files. Use `/investigate` as the shortcut.

## Personal Overrides

Create `CLAUDE.local.md` at the project root to add personal preferences that won't be committed:

```markdown
# My personal overrides
- I prefer verbose explanations
- Always suggest pnpm commands, not npm
```

This file is gitignored.
