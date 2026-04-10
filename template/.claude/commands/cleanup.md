Run a full code quality audit on the file(s) specified in $ARGUMENTS. If no argument is given, audit files changed since the last commit.

Check each area below and report findings. Group issues by severity: **critical** (blocks ship), **warning** (should fix), **suggestion** (nice to have).

---

## 1. Accessibility (WCAG AA)

- Do all interactive elements have accessible labels (`aria-label`, `aria-labelledby`, or visible text)?
- Is keyboard navigation supported — logical tab order, no keyboard traps?
- Are focus rings visible on all interactive elements?
- Does color contrast meet 4.5:1 (normal text) and 3:1 (large text / UI components)?
- Do images have meaningful `alt` text, or `alt=""` for decorative images?
- Are form inputs associated with labels (`<label htmlFor>` or `aria-labelledby`)?
- Are touch targets at least 44×44px?
- Is `prefers-reduced-motion` respected for animations — use `motion-safe:` / `motion-reduce:` Tailwind variants or check `useReducedMotion()`?
- Does dynamic content that updates without a page reload announce changes to screen readers (live regions, role="status")?

## 2. Motion & Animation

- Do conditional renders of animated elements use `AnimatePresence` (if using Framer Motion) to handle exit animations?
- Are dynamic inline styles that change over time using proper transitions instead of abrupt jumps?
- Are Tailwind `transition-*` classes conflicting with Framer Motion's style injection on the same element?
- If Framer Motion is used, is `LazyMotion` with `domAnimation` or `domMax` used instead of the full `motion` bundle for non-critical animations?
- Are animation durations reasonable — not so fast they're imperceptible, not so slow they feel laggy?

## 3. Design System Compliance

- Are all colors using CSS variables (`--color-*`, `--background`, `--foreground`, etc.) — no hardcoded hex, rgb, or named colors?
- Are existing shadcn/ui primitives being reused where appropriate — not reimplementing a `<Dialog>`, `<Tooltip>`, `<Select>`, etc. from scratch?
- Are responsive breakpoints covered — does the component work at mobile, tablet, and desktop widths?
- Is `cn()` used for all conditional or merged class names — no template literals or manual string concatenation for classes?
- Is Tailwind v4 syntax used — `@theme` in CSS, not `tailwind.config.js` overrides?

## 4. Code Quality

- Are there any `any` types? Replace with proper types or `unknown` + type narrowing.
- Are all props typed? Is the prop interface complete with no missing optional/required distinctions?
- Is the component over 200 lines? If so, what should be extracted into sub-components or hooks?
- Is there prop drilling past 2 levels? Consider composition or context.
- Are there side effects (fetch, subscriptions) happening directly in the component body instead of inside `useEffect` or a custom hook?
- Do async operations have error handling? Are loading and error states handled in the UI?
- Are there missing error boundaries for components that make async calls or render third-party content?

## 5. Semantic HTML

- Are `<button>` elements used for actions and `<a>` for navigation — not `<div onClick>`?
- Is the heading hierarchy correct — one `<h1>` per page, no skipped levels?
- Are lists using `<ul>` / `<ol>` + `<li>` rather than `<div>` sequences?
- Do form elements use proper `<fieldset>` + `<legend>` grouping where applicable?
- Are landmark regions present where expected (`<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`)?

---

## Output Format

For each section, provide:
- **Pass** ✅ / **Fail** ❌ / **Warning** ⚠️
- Specific line-level callouts for each issue
- Suggested fix for each failure

End with a summary of total critical / warning / suggestion counts and offer to apply the fixes automatically.
