---
name: e2e-testing
description: E2E testing with Playwright — file structure, test naming, locator priority (getByRole first), assertions, page object pattern, CI considerations
---

# E2E Testing with Playwright

Guidance for writing and running Playwright tests in this project.

## File Structure

```
e2e/
├── {feature}.spec.ts      # Test files grouped by feature
├── fixtures/              # Custom fixtures and test data
│   └── index.ts
└── helpers/               # Shared page helpers
    └── {page-name}.ts
```

## Writing Tests

### Test Structure
```ts
import { test, expect } from "@playwright/test"

test.describe("Feature name", () => {
  test.beforeEach(async ({ page }) => {
    await page.goto("/route")
  })

  test("does the thing the user expects", async ({ page }) => {
    // Arrange
    // Act
    // Assert
  })
})
```

### Locator Priority (best to worst)
1. `getByRole` — always prefer ARIA roles
2. `getByLabel` — form inputs
3. `getByText` — visible text
4. `getByTestId` — last resort (`data-testid` attribute)

Never use CSS selectors or XPath.

### Good Test Names
Tests should describe user behavior, not implementation:
```ts
// ✅
test("shows validation error when email is empty")
test("redirects to dashboard after successful login")

// ❌
test("LoginForm validation")
test("submit button click")
```

## Assertions

```ts
// Visibility
await expect(page.getByRole("alert")).toBeVisible()
await expect(page.getByText("Success")).toBeHidden()

// Text content
await expect(page.getByRole("heading")).toHaveText("Dashboard")

// URL
await expect(page).toHaveURL("/dashboard")

// Form state
await expect(page.getByRole("button", { name: "Submit" })).toBeDisabled()
```

## Running Tests

```bash
# Run all E2E tests
pnpm playwright test

# Run with UI (headed, interactive)
pnpm playwright test --ui

# Run specific file
pnpm playwright test e2e/auth.spec.ts

# Debug a specific test
pnpm playwright test --debug -g "test name"
```

## Page Object Pattern

For complex flows, use page objects to keep tests readable:

```ts
// e2e/helpers/login-page.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto("/login")
  }

  async fillEmail(email: string) {
    await this.page.getByLabel("Email").fill(email)
  }

  async submit() {
    await this.page.getByRole("button", { name: "Sign in" }).click()
  }
}
```

## CI Considerations

- Tests run headless in CI
- Use `test.skip` with a reason, never comment out tests
- Flaky tests should be investigated and fixed, not retried blindly
- `playwright.config.ts` sets baseURL from `PLAYWRIGHT_BASE_URL` env var
