# AI Tooling Setup

This project uses Claude Code with a shared configuration for consistent AI-assisted development.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed: `npm install -g @anthropic-ai/claude-code`
- pnpm installed: `npm install -g pnpm`

## Project-Scoped Tools (automatic)

The following MCP servers are configured in `.mcp.json` and activate automatically when you open this project in Claude Code:

| Server | Purpose |
|--------|---------|
| **context7** | Live, version-pinned docs for any library |
| **shadcn** | shadcn/ui component registry and search |

These require no setup — Claude Code starts them automatically.

## Personal Tools (one-time setup)

Some tools require personal credentials and are installed at the user scope. Run the setup script once on your machine:

```bash
bash scripts/setup-user-tools.sh
```

This will walk you through setting up:
- **GitHub MCP** — PR and issue management from within Claude Code
- **Figma MCP** — Design file access (requires Figma personal access token)
- **Vercel MCP** — Deployment management (requires Vercel token)
- **Chrome DevTools MCP** — Browser debugging and inspection

## Available Skills

Claude Code will automatically pick up these project skills:

- **component-patterns** — Compound components, cva variants, hook extraction rules
- **project-conventions** — Import ordering, path aliases, file creation checklists

## Available Commands

Type these in Claude Code to trigger specific workflows:

| Command | Description |
|---------|-------------|
| `/design-review` | Audit a component against design system, a11y, and composition rules |
| `/generate-component` | Scaffold a new component with tests, types, and barrel export |

## Personal Overrides

Create `CLAUDE.local.md` at the project root to add personal preferences that won't be committed:

```markdown
# My personal overrides
- I prefer verbose explanations
- Always suggest pnpm commands, not npm
```

This file is gitignored.
