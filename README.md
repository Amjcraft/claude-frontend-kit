# frontend-agent-toolkit

A reusable Claude Code configuration layer for React/Next.js/Tailwind/shadcn-ui projects. Drop it into any new project to give Claude Code consistent conventions, skills, commands, MCP servers, subagents, and automatic formatting hooks — out of the box.

## What gets installed

### Base (always)

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Lean session context — stack, commands, file structure, core conventions, MCP reference, agent workflow |
| `.mcp.json` | Project-scoped MCP servers (Context7, shadcn) |
| `AI-TOOLING-SETUP.md` | Teammate onboarding doc |
| `.claude/settings.json` | PostToolUse hooks — auto-runs prettier + eslint after every TS/TSX edit |
| `.claude/skills/component-patterns/` | Compound components, cva variants, forwardRef, hook extraction |
| `.claude/skills/project-conventions/` | Import ordering, path aliases, file checklists, naming, Tailwind v4 |
| `.claude/agents/code-explorer.md` | Read-only subagent — investigates codebase without touching main context |
| `.claude/agents/pr-reviewer.md` | Read-only subagent — runs the full polish checklist for pre-PR audits |
| `.claude/commands/plan.md` | `/plan` — Phase 0: delegate codebase scan to code-explorer, produce structured plan |
| `.claude/commands/execute-plan.md` | `/execute-plan` — walk a plan file step-by-step with per-step verification |
| `.claude/commands/generate-component.md` | `/generate-component` — Phase 1 helper: scaffold a component with tests + barrel export |
| `.claude/commands/cleanup.md` | `/cleanup` — Phase 2 audit: accessibility, motion, design system, code quality |
| `.claude/commands/polish.md` | `/polish` — Phase 3 audit: delegates to pr-reviewer, returns ship-readiness verdict |
| `.claude/commands/investigate.md` | `/investigate` — answer a codebase question via code-explorer without filling main context |

### Optional modules

| Module | Adds |
|--------|------|
| `figma` | Figma MCP (user-scoped) + design handoff skill |
| `playwright` | Playwright MCP (project-scoped) + E2E skill + `/generate-e2e-test` command |
| `vercel` | Vercel MCP (user-scoped) + `/deploy-check` command |
| `storybook` | Storybook skill (auto-activates on story files) + `/generate-story` command |

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

The planning command delegates codebase investigation to the `code-explorer` subagent, which reads files without consuming main context. The main session uses the explorer's summary to write a structured plan — keeping Phase 0 lean even on large codebases.

**What it does:**
1. Delegates context gathering to `code-explorer` — routes, data fetching, auth, forms, DB, shadcn primitives, reusable utilities
2. Breaks the feature into discrete units mapped to exact file paths (new files, modified files, reusable existing code)
3. Identifies data requirements, API/server action needs, and dependency chains
4. Flags open questions — anything ambiguous that needs a human decision before work starts
5. Writes the plan to `docs/plans/[feature-name].md` with a "Done when:" verification clause per step

### Phase 1 — Create (always-on)

Skills load automatically at session start. Each skill has a tight `description` in its YAML frontmatter (~100 tokens) that Claude reads every session; the full skill body only loads when the task is relevant.

| Skill | What it covers |
|-------|---------------|
| `component-patterns` | Compound components, cva variants, forwardRef, hook extraction, cn() |
| `project-conventions` | Import ordering, path aliases, file structure, naming, Tailwind v4, shadcn/ui rules |

Once a plan exists in `docs/plans/`, use `/execute-plan [name]` to walk through it step-by-step. Each step is verified against its "Done when:" clause before moving on.

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

Run `/polish [file or scope]` before opening a PR. Delegates to the `pr-reviewer` subagent, which runs the full checklist against the scope without filling main context with file reads. Audits across:
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
| Full skill body (activated) | ~800–2000 tokens | Only when task matches |
| `code-explorer` subagent | isolated context | `/plan`, `/investigate` |
| `pr-reviewer` subagent | isolated context | `/polish` |
| `/execute-plan` overhead | ~200 tokens | Only when invoked |
| `/cleanup` context | ~3000–5000 tokens | Only when invoked |

Phase 1 creation sessions stay lean: CLAUDE.md + 2 skill descriptions + 1 activated skill body = ~2000–3500 tokens of overhead. Subagents run in isolated contexts — their file reads never appear in the main session.

### Typical workflows

**New feature (all phases):**
```
/plan Add a team member invitation flow with email magic links
  → code-explorer investigates codebase in isolation
  → Main session writes docs/plans/team-invitations.md with Done when: clauses
  → Review the plan, answer open questions

/execute-plan team-invitations
  → Executes each step, verifies Done when: before moving on
  → Stops and reports if any step fails verification

/cleanup src/components/invitations/ src/app/settings/invitations/
  → Checks a11y, motion, design system, code quality, semantic HTML

/polish
  → pr-reviewer audits in isolation, returns verdict
```

**Bug fix (Phase 1 only):**
```
Fix the date picker not closing on selection in InvoiceForm
  → Claude uses always-on skills, fixes the bug
  → Hooks auto-format the edited file
```

**Investigate without polluting context:**
```
/investigate how does session refresh work in this app
  → code-explorer reads auth files and returns a summary
  → Main session never sees the raw file contents
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
│       ├── settings.json    # PostToolUse hooks (prettier, eslint, optional tsc)
│       ├── agents/
│       │   ├── code-explorer.md
│       │   └── pr-reviewer.md
│       ├── skills/
│       │   ├── component-patterns/SKILL.md
│       │   └── project-conventions/SKILL.md
│       └── commands/
│           ├── plan.md
│           ├── execute-plan.md
│           ├── investigate.md
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
