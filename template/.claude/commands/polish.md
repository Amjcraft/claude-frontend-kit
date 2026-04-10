Run a pre-ship readiness audit on the file(s) or feature specified in $ARGUMENTS. If no argument is given, audit the current branch diff against main.

This is a Phase 3 check — run this before opening a PR. Assumes `/cleanup` has already been run.

---

## 1. SEO

- Does every page export a `metadata` object (or `generateMetadata`) with `title` and `description`?
- Are Open Graph tags present (`og:title`, `og:description`, `og:image`)?
- Is the heading structure correct — one `<h1>` per page that matches the page's purpose?
- Are meaningful, descriptive URLs used — no query-string-only routes for indexable content?
- Is structured data (JSON-LD schema) present where appropriate (articles, products, FAQs)?
- Are canonical tags set for pages with duplicate or near-duplicate content?

## 2. Performance

- Are images using `next/image` — not bare `<img>` tags?
- Do images have explicit `width` and `height` (or `fill` with a sized container) to prevent layout shift?
- Are heavy third-party components or large libraries lazy-loaded with `dynamic(() => import(...), { ssr: false })`?
- Are large lists or tables virtualized (e.g. `react-virtual`) if they can exceed ~50 items?
- Does any new dependency significantly increase the bundle? Check with `next build --analyze` if uncertain.
- Are Core Web Vitals concerns addressed — LCP element identifiable and not lazy-loaded, no CLS from unsized media, INP-sensitive interactions debounced or deferred?
- Are Server Components used by default, and Client Components only where interactivity or browser APIs require it?

## 3. Visual Quality

- Does the component look intentional at all breakpoints — not generic or AI-default-styled?
- Are spacing, typography, and color consistent with the rest of the design system?
- Are loading and empty states designed (skeletons, placeholders) — not just blank space?
- Are error states visually clear and actionable, not just raw error strings?
- Does the component handle long strings, overflow, and edge-case content gracefully (truncation, wrapping)?
- Does animation/motion feel purposeful — not decorative noise?

## 4. Responsiveness

- Does the layout work correctly at 375px (mobile), 768px (tablet), and 1280px (desktop)?
- Are touch targets large enough on mobile (44×44px minimum)?
- Is horizontal overflow prevented — no content spilling outside the viewport?
- Does the component adapt its layout (e.g. stack vs. side-by-side) at appropriate breakpoints?
- Are modals, drawers, and overlays usable on mobile — not cut off or unscrollable?

## 5. Test Coverage

- Does every component have at least one test covering its primary behavior?
- Are critical user interactions covered — form submission, toggle states, conditional renders?
- Are error and loading states tested, not just the happy path?
- Do E2E tests exist for any user-facing flows touched by this change?
- Are tests using accessible queries (`getByRole`, `getByLabelText`) rather than test IDs where possible?

---

## Output Format

For each section, provide:
- **Pass** ✅ / **Fail** ❌ / **Warning** ⚠️
- Specific callouts for each issue with file and line where applicable
- Recommended fix or next step for each failure

End with a ship-readiness verdict: **Ready** ✅, **Ready with minor fixes** ⚠️, or **Not ready** ❌, with a prioritized list of what to address before merging.
