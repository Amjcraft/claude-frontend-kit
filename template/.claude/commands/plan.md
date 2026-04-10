Analyze the feature described in $ARGUMENTS and produce a structured implementation plan. This is a read-only phase — scan the codebase, reason about the work, and write a plan file. Do not create or modify any source files.

---

## Step 1 — Context Gathering (read-only)

Before writing anything, scan the project to understand its current state:

- **Project structure** — routes (`src/app/`), components, hooks, lib utilities, types
- **Data fetching pattern** — Server Components, TanStack Query, SWR, plain fetch? Look at existing pages and components to identify the established approach
- **Auth pattern** — how is authentication handled? What session/user data is available and where?
- **Form handling** — is react-hook-form used? Zod for validation? Look at existing forms
- **Database / API layer** — ORM (Prisma, Drizzle)? Server actions or REST routes? Both?
- **Email or external services** — any existing integrations relevant to this feature?
- **Installed shadcn/ui components** — scan `src/components/ui/` to know what's already available
- **Existing patterns to reuse** — components, hooks, utilities that this feature can build on

Do not propose a new approach if one already exists. Follow established project patterns.

---

## Step 2 — Feature Analysis

Break the feature into discrete units of work:

- Map each unit to **new files** (exact paths), **modified files** (exact paths), and **reusable existing components/hooks**
- Identify **data requirements**: what data this feature needs, where it comes from, what new server actions or API routes are required
- Flag **dependency chains**: what must exist before what (e.g., DB schema before server actions, server actions before UI)
- Note **open questions**: anything ambiguous that requires a human decision before implementation can start (external services, design decisions, scope questions)

---

## Step 3 — Write the Plan File

Create the directory if it doesn't exist, then write the plan to:

```
docs/plans/[kebab-case-feature-name].md
```

Use this exact template:

```markdown
# Feature Plan: [Feature Name]

## Summary
One paragraph describing what this feature does and why.

## Open Questions
Decisions that need human input before implementation starts.
- [ ] Question 1
- [ ] Question 2

## Scope

### New Files
- `path/to/file.tsx` — what it does
- `path/to/file.ts` — what it does

### Modified Files
- `path/to/existing.tsx` — what changes and why

### Reusable Existing Components / Hooks
- `ComponentName` from `@/components/...` — how it's used here
- `useHookName` from `@/hooks/...` — how it's used here

## Data Flow
How data moves through the feature — user action → server action or API → database → revalidation → UI update.

## Implementation Order
Ordered sequence respecting dependency chains:
1. Step one (e.g., database schema)
2. Step two (e.g., server actions)
3. ...

## Technical Notes
Non-obvious decisions, edge cases to handle, performance considerations, or alternatives considered and rejected.
```

---

## Step 4 — Summary Output

After writing the plan file, output:

1. The path to the plan file
2. A brief summary of the feature scope (new files count, modified files count)
3. Any open questions that need answers before work starts
4. Confirmation that no source files were created or modified

---

## Behavior Rules

- **Read-only.** The only file you may create is the plan in `docs/plans/`. No source file creation, no code generation.
- **Ask, don't assume.** Anything ambiguous goes in Open Questions — do not pick an approach without flagging it.
- **Exact paths.** File paths must be specific (e.g., `src/app/settings/invitations/page.tsx`), not vague descriptions.
- **Respect existing patterns.** If the project uses Server Components for data fetching, the plan uses Server Components. Don't introduce new patterns unless the existing ones genuinely can't support this feature.
- **Sequence respects dependencies.** Implementation order must reflect real chains — a UI component that calls a server action cannot be listed before the server action exists.
