# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Stack

- **Framework**: Next.js (App Router)
- **Language**: TypeScript (strict mode)
- **Styling**: Tailwind CSS v4 — CSS-first `@theme` directive, no `tailwind.config.js`
- **Components**: shadcn/ui — install via CLI, never modify `components/ui/` directly
- **Package manager**: pnpm
- **Testing**: Vitest (unit), Playwright (E2E)
- **Git**: Conventional commits, squash merge to main

## Commands

```bash
pnpm dev          # start dev server
pnpm build        # production build
pnpm lint         # eslint
pnpm typecheck    # tsc --noEmit
pnpm test         # vitest
pnpm test:e2e     # playwright
```

## File Structure

```
src/
├── app/            # Next.js App Router pages and layouts
├── components/
│   ├── ui/         # shadcn/ui primitives (do not edit)
│   └── {feature}/  # feature components
├── hooks/          # custom hooks (use-*.ts)
├── lib/            # utilities and helpers
└── types/          # shared TypeScript types
```

Component folder structure:
```
src/components/{category}/{name}/
├── {name}.tsx
├── {name}.test.tsx
└── index.ts        # barrel export
```

## Core Conventions

- TypeScript strict mode — no `any`, prefer `type` over `interface` for props
- Mobile-first responsive design
- Semantic HTML, WCAG AA baseline
- `cn()` for all class merging
- CSS variables for all theming — no hardcoded colors
- `@/` path aliases — never use `../../../`
- No prop drilling past 2 levels — use composition or context

## Git Workflow

- Branch naming: `feat/`, `fix/`, `chore/`, `docs/`
- Commit format: `type(scope): description`
- PRs squash-merge to main
- Never commit directly to main

## Environment Variables

- All env vars defined in `.env.example` with placeholder values
- Client-side vars: `NEXT_PUBLIC_` prefix
- Never hardcode secrets — access through a typed `src/lib/config.ts` module

## Testing

- Unit tests colocated with component (`component.test.tsx`)
- Test behavior, not implementation details
- E2E tests in `e2e/` at project root

## MCP Servers

Use these on demand when the task calls for it:
- **context7** — up-to-date library docs and version-accurate code examples
- **shadcn** — shadcn/ui component reference and install commands
- **github** *(user-scoped)* — PR and issue management

## Agent Workflow

This project uses a phased approach to keep each session context lean:

| Phase | Trigger | What it covers |
|-------|---------|----------------|
| 0 — Plan | `/plan [feature description]` | Codebase analysis, structured plan, open questions |
| 1 — Create | Always-on skills | Component patterns, project conventions |
| 2 — Cleanup | `/cleanup [file]` | Accessibility, motion, design system, code quality |
| 3 — Polish | `/polish [file]` | SEO, performance, visual quality, test coverage |

Not every task needs all four phases. A bug fix can skip Phase 0 and 3. A new feature uses all four.

**If a plan exists** in `docs/plans/`, read it before writing any code and follow the implementation order it defines.
