Review the component at $ARGUMENTS against this project's design system and quality standards.

Audit across these areas and report findings for each:

## 1. Composition & API Design
- Does it use compound components where appropriate, or does it have boolean prop sprawl?
- Are variants defined with `cva` rather than conditional classNames or booleans?
- Is prop drilling limited to 2 levels max?
- Is the component under 200 lines? If not, what should be extracted?

## 2. Tailwind & Styling
- Are all class merges going through `cn()`?
- Are any colors hardcoded instead of using CSS variables (`--color-primary`, etc.)?
- Is the design mobile-first (base styles are mobile, `md:` and up are overrides)?
- Are shadcn/ui primitives being modified directly (❌) or extended via wrappers/classNames (✅)?

## 3. Accessibility (WCAG AA)
- Do interactive elements have accessible labels (`aria-label`, `aria-labelledby`, or visible text)?
- Is keyboard navigation supported (focus styles visible, tab order logical)?
- Are focus rings present and visible on all interactive elements?
- Is color contrast sufficient (4.5:1 for normal text, 3:1 for large text)?
- Do images have meaningful alt text (or `alt=""` for decorative images)?
- Are form inputs associated with labels?

## 4. TypeScript
- Are there any `any` types?
- Are props typed with `type` (preferred over `interface` for component props)?
- Are event handler types correct (`React.MouseEvent`, etc.)?
- Is `forwardRef` used if this wraps a native element?

## 5. Conventions
- Does import ordering follow the project standard (React → third-party → aliases → relative → types)?
- Is the file in the right location per project structure?
- Does it have a co-located test file and barrel export?

---

Provide a summary with:
- **Pass** ✅ / **Fail** ❌ / **Warning** ⚠️ for each area
- Specific line-level callouts for issues
- Suggested fixes for each failure
