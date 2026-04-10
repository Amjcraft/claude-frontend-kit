# frontend-agent-toolkit

A reusable Claude Code configuration layer for React/Next.js/Tailwind/shadcn-ui projects. Drop it into any new project to give Claude Code consistent conventions, skills, commands, and MCP servers — out of the box.

## What gets installed

### Base (always)

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Lean session context — stack, commands, file structure, core conventions, MCP reference, agent workflow |
| `.mcp.json` | Project-scoped MCP servers (Context7, shadcn) |
| `AI-TOOLING-SETUP.md` | Teammate onboarding doc |
| `.claude/skills/component-patterns/` | Compound components, cva variants, forwardRef, hook extraction |
| `.claude/skills/project-conventions/` | Import ordering, path aliases, file checklists, naming, Tailwind v4 |
| `.claude/commands/plan.md` | `/plan` — Phase 0: scan codebase, analyze feature, produce structured plan |
| `.claude/commands/generate-component.md` | `/generate-component` — Phase 1 helper: scaffold a component with tests + barrel export |
| `.claude/commands/cleanup.md` | `/cleanup` — Phase 2 audit: accessibility, motion, design system, code quality |
| `.claude/commands/polish.md` | `/polish` — Phase 3 audit: SEO, performance, visual quality, test coverage |

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
- **Tailwind CSS v4** + **shadcn/ui**
- **pnpm**
- **Vitest** (unit) + **Playwright** (E2E)
- Conventional commits, squash merge to main

## Phased agent workflow

The toolkit uses a four-phase approach to keep context lean during development. Each phase loads only what's needed for that stage of work. Not every task needs all four — a bug fix can skip Phase 0 and 3; a refactor might skip Phase 3.

```
Phase 0: Plan  →  Phase 1: Create  →  Phase 2: Cleanup  →  Phase 3: Polish
(read-only)       (write code)         (fix issues)          (ship-ready)
```

### Phase 0 — Plan (on-demand)

Run `/plan [feature description]` before writing any code for a new feature or significant refactor.

The planning agent is **read-only** — it scans the codebase, analyzes the feature request, and produces a structured markdown plan. No source files are created or modified.

**What it does:**
1. Scans project structure, routing, data fetching patterns, auth, forms, installed shadcn/ui components, and any relevant existing utilities
2. Breaks the feature into discrete units mapped to exact file paths (new files, modified files, reusable existing code)
3. Identifies data requirements, API/server action needs, and dependency chains (what must exist before what)
4. Flags open questions — anything ambiguous that needs a human decision before work starts
5. Writes the plan to `docs/plans/[feature-name].md`

The plan file is the handoff to Phase 1. Once approved, Phase 1 reads the plan and executes it in order rather than interpreting a loose feature description.

### Phase 1 — Create (always-on)

Skills load automatically at session start. Each skill has a tight `description` in its YAML frontmatter (~100 tokens) that Claude reads every session; the full skill body only loads when the task is relevant.

| Skill | What it covers |
|-------|---------------|
| `component-patterns` | Compound components, cva variants, forwardRef, hook extraction, cn() |
| `project-conventions` | Import ordering, path aliases, file structure, naming, Tailwind v4, shadcn/ui rules |

**CLAUDE.md is kept intentionally lean** — stack declaration, commands, file structure, and core conventions only. Nothing that belongs in a phase-specific command.

### Phase 2 — Cleanup (on-demand)

Run `/cleanup [file or dir]` after writing code. Audits across:
- **Accessibility** — WCAG AA, ARIA, keyboard nav, focus rings, color contrast, touch targets, reduced-motion
- **Motion & animation** — AnimatePresence usage, transition conflicts, LazyMotion bundle size
- **Design system compliance** — CSS variable usage, shadcn/ui reuse, responsive coverage, cn()
- **Code quality** — TypeScript strictness, prop completeness, component size, prop drilling, error handling
- **Semantic HTML** — button vs. anchor, heading hierarchy, landmark regions, form associations

Reports issues as **critical** / **warning** / **suggestion** and offers to apply fixes.

### Phase 3 — Polish (on-demand)

Run `/polish [file or dir]` before opening a PR. Audits across:
- **SEO** — metadata, Open Graph, heading structure, schema markup
- **Performance** — next/image, lazy loading, bundle impact, Core Web Vitals, Server Components
- **Visual quality** — intentional design, loading/empty/error states, overflow handling
- **Responsiveness** — mobile/tablet/desktop layout, touch targets, overlay usability
- **Test coverage** — primary behaviors, edge cases, E2E for user-facing flows

Returns a ship-readiness verdict: **Ready** ✅, **Ready with minor fixes** ⚠️, or **Not ready** ❌.

### Token budget

| Layer | Cost | When |
|-------|------|------|
| CLAUDE.md | ~500 tokens | Every session |
| Skill descriptions (×2) | ~100 tokens each | Every session |
| Full skill body (activated) | ~1000–3000 tokens | Only when task matches |
| `/plan` context | ~2000–3000 tokens | Only when invoked |
| `/cleanup` context | ~3000–5000 tokens | Only when invoked |
| `/polish` context | ~2000–3000 tokens | Only when invoked |

Phase 1 creation sessions stay lean: CLAUDE.md + 2 skill descriptions + 1 activated skill body = ~2000–4000 tokens of overhead. Everything else only loads when you ask for it.

### Typical workflows

**New feature (all phases):**
```
/plan Add a team member invitation flow with email magic links
  → Claude scans codebase, writes docs/plans/team-invitations.md, surfaces open questions
  → Review the plan, answer questions, adjust scope

[Plan approved — Phase 1 begins]
  → Claude reads the plan and executes: schema → server actions → email util → components → page → tests

/cleanup src/components/invitations/ src/app/settings/invitations/
  → Checks a11y, motion, design system, code quality, semantic HTML

/polish
  → Checks SEO, performance, responsiveness, test coverage before PR
```

**Bug fix (Phase 1 only):**
```
Fix the date picker not closing on selection in InvoiceForm
  → Claude uses always-on skills, fixes the bug
```

**Refactor (Phase 0 + 1 + 2):**
```
/plan Refactor the dashboard to use Server Components for data fetching
  → Plan produced

[Execute refactor following the plan]

/cleanup src/app/dashboard/
  → Verify nothing broke
```

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
│           ├── plan.md
│           ├── generate-component.md
│           ├── cleanup.md
│           └── polish.md
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
