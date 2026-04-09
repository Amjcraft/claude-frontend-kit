# frontend-agent-toolkit

A reusable Claude Code configuration layer for React/Next.js/Tailwind/shadcn-ui projects. Drop it into any new project to give Claude Code consistent conventions, skills, commands, and MCP servers — out of the box.

## What gets installed

### Base (always)

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project instructions — conventions, patterns, git workflow |
| `.mcp.json` | Project-scoped MCP servers (Context7, shadcn) |
| `AI-TOOLING-SETUP.md` | Teammate onboarding doc |
| `.claude/skills/component-patterns/` | Compound components, cva variants, forwardRef, hook extraction |
| `.claude/skills/project-conventions/` | Import ordering, path aliases, file checklists, naming |
| `.claude/commands/design-review.md` | `/design-review` — audit a component against design system + a11y |
| `.claude/commands/generate-component.md` | `/generate-component` — scaffold component with tests + barrel export |

### Optional modules

| Module | Adds |
|--------|------|
| `figma` | Figma MCP (user-scoped) + design handoff skill |
| `playwright` | Playwright MCP (project-scoped) + E2E skill + `/generate-e2e-test` command |
| `vercel` | Vercel MCP (user-scoped) + deployment skill |
| `storybook` | Storybook skill + `/generate-story` command |

## Install

Clone the toolkit once, then run the installer from inside any project:

```bash
# Clone toolkit somewhere on your machine (one-time)
git clone https://github.com/your-username/frontend-agent-toolkit.git ~/tools/frontend-agent-toolkit

# From inside your project
cd your-project
bash ~/tools/frontend-agent-toolkit/install.sh
```

The script will prompt you for:
1. **Project name** — injected into `CLAUDE.md`
2. **Project description** — injected into `CLAUDE.md`
3. **Modules** — toggle which optional modules to install

It's safe to re-run. Existing files are skipped (not overwritten).

## Stack assumptions

The base template is built for:
- **Next.js** (App Router)
- **TypeScript** (strict mode)
- **Tailwind CSS** + **shadcn/ui**
- **pnpm**
- **Vitest** (unit) + **Playwright** (E2E)
- Conventional commits, squash merge to main

## After install

1. **Customize `CLAUDE.md`** — add project-specific context, API details, team notes
2. **Commit the config files:**
   ```bash
   git add CLAUDE.md .mcp.json AI-TOOLING-SETUP.md .claude/
   git commit -m "chore: add Claude Code project config"
   ```
3. **Share `AI-TOOLING-SETUP.md`** with teammates — it explains what's configured and how to set up their personal tools
4. **Open Claude Code** in the project — it will pick up all the config automatically

## Personal overrides (gitignored)

Create `CLAUDE.local.md` in your project root for personal preferences that stay off version control:

```markdown
# My personal overrides
- Prefer verbose explanations
- Always use pnpm, never npm
```

## What's gitignored

The install script appends these to your project's `.gitignore`:

```
CLAUDE.local.md
.claude/settings.local.json
```

## Project structure

```
frontend-agent-toolkit/
├── install.sh               # Installer script
├── README.md
├── template/                # Base files (always installed)
│   ├── CLAUDE.md
│   ├── .mcp.json
│   ├── AI-TOOLING-SETUP.md
│   ├── .gitignore.claude
│   └── .claude/
│       ├── skills/
│       │   ├── component-patterns/SKILL.md
│       │   └── project-conventions/SKILL.md
│       └── commands/
│           ├── design-review.md
│           └── generate-component.md
└── modules/
    ├── figma/
    ├── playwright/
    ├── vercel/
    └── storybook/
```

## Adding a new module

1. Create `modules/{name}/` with:
   - `meta.json` — name, description, mcpScope, requiresEnv, setupPrompt
   - `mcp-entry.json` — MCP server config block (if applicable)
   - `template/` — files to copy into the project (mirrors project structure)
2. Add the module name and description to the `AVAILABLE_MODULES` and `MODULE_DESCS` arrays in `install.sh`
