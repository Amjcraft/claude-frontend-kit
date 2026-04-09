# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## Stack

- **Framework**: Next.js (App Router)
- **Language**: TypeScript (strict mode)
- **Styling**: Tailwind CSS + shadcn/ui
- **Package manager**: pnpm
- **Unit tests**: Vitest
- **E2E tests**: Playwright
- **Git**: Conventional commits, squash merge to main

## Code Style

### TypeScript
- Strict mode, no `any`
- Prefer `type` over `interface` for props
- Export types alongside components

### Components
- Composition over configuration — avoid boolean prop sprawl
- shadcn/ui primitives are never modified directly; extend via Tailwind or wrapper components
- Use `cn()` for all conditional class merging
- CSS variables for all theming — never hardcode color values
- Mobile-first responsive design
- WCAG AA accessibility baseline — always include aria labels, keyboard nav, focus states
- 200-line max per component file; extract logic to hooks when approaching that

### File Structure
Colocate related files:
```
src/components/ui/button/
├── button.tsx
├── button.test.tsx
└── index.ts          # barrel export
```

### Imports
Order strictly:
1. React and Next.js
2. Third-party libraries
3. Path aliases (`@/components`, `@/lib`, etc.)
4. Relative imports
5. Type-only imports (`import type`)

### Path Aliases
Use `@/` for all non-relative imports. Never use `../../../`.

## Component Patterns

### Variants with cva
```tsx
import { cva, type VariantProps } from "class-variance-authority"

const buttonVariants = cva("base-classes", {
  variants: {
    variant: { default: "...", destructive: "..." },
    size: { sm: "...", md: "...", lg: "..." },
  },
  defaultVariants: { variant: "default", size: "md" },
})

type ButtonProps = React.ComponentProps<"button"> & VariantProps<typeof buttonVariants>
```

### Compound Components
Prefer compound component pattern for complex UI (avoid deeply nested prop trees):
```tsx
<Card>
  <Card.Header>
  <Card.Body>
  <Card.Footer>
</Card>
```

### Hook Extraction
Extract to a custom hook when:
- State logic exceeds ~20 lines
- Logic is reused in 2+ places
- Side effects (fetch, subscriptions) are involved

No prop drilling past 2 levels. Use composition or context.

## Git Workflow

- Branch naming: `feat/`, `fix/`, `chore/`, `docs/`
- Commit format: `type(scope): description` (conventional commits)
- PRs squash-merge to main
- Never commit directly to main

## Environment Variables

- All env vars must be defined in `.env.example` with a placeholder value
- Client-side vars prefixed with `NEXT_PUBLIC_`
- Never hardcode secrets or API keys in source

## Testing

- Unit tests colocated with component (`component.test.tsx`)
- Test behavior, not implementation
- E2E tests in `e2e/` at project root
- Descriptive test names: `it("shows error message when form is invalid")`
