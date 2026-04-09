Generate a Playwright E2E test for the feature or flow described in $ARGUMENTS.

Before writing:
1. Identify the user flows to cover (happy path + key failure cases)
2. Identify which pages/routes are involved
3. Check if a page helper exists in `e2e/helpers/` for relevant pages

Generate:

## Test file — `e2e/{feature-name}.spec.ts`

- `test.describe` block named after the feature
- `test.beforeEach` for shared setup (navigation, auth if needed)
- Separate `test()` for each scenario
- Use role-based locators (`getByRole`, `getByLabel`, `getByText`) — no CSS selectors
- Descriptive test names describing user behavior
- Arrange / Act / Assert structure with comments

## Page helper (if needed) — `e2e/helpers/{page-name}.ts`

Only generate if:
- The page is complex enough to reuse across multiple tests
- A helper doesn't already exist for this page

---

After generating, list:
- Tests created and what scenario each covers
- Any env vars needed (e.g., test user credentials)
- How to run: `pnpm playwright test e2e/{feature-name}.spec.ts`
