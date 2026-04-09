Scaffold a new component based on the description in $ARGUMENTS.

Parse the input for:
- **Component name** (PascalCase)
- **Category** (e.g., `ui`, `forms`, `layout`, `features/{feature-name}`)
- **Variant needs** — does it need size/style variants? (use cva)
- **Element type** — does it wrap a native element? (use forwardRef)

Generate all of the following files:

## 1. Component file — `src/components/{category}/{kebab-name}/{kebab-name}.tsx`

- Proper import ordering (React → third-party → aliases → relative → types)
- `cva` variants if the component has style/size variations
- `forwardRef` if it wraps a native HTML element
- `cn()` for all className merging
- Exported `{Name}Props` type
- `displayName` set if using forwardRef
- JSDoc comment describing the component's purpose
- Under 200 lines

## 2. Test file — `src/components/{category}/{kebab-name}/{kebab-name}.test.tsx`

- Uses Vitest + React Testing Library
- Import pattern: `import { render, screen } from "@testing-library/react"`
- Tests for: renders without crashing, key variants render correct output, accessibility (role queries preferred over testid)
- Descriptive test names: `it("shows disabled state when disabled prop is passed")`

## 3. Barrel export — `src/components/{category}/{kebab-name}/index.ts`

```ts
export { ComponentName } from "./component-name"
export type { ComponentNameProps } from "./component-name"
```

---

After generating, provide:
- The full file tree created
- Any shadcn/ui primitives used and how to install them (`pnpm dlx shadcn@latest add {name}`)
- Any additional setup needed (context providers, peer dependencies)
