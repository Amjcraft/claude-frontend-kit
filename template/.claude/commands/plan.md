Analyze the feature described in $ARGUMENTS and produce a structured implementation plan. This is a read-only phase — scan the codebase, reason about the work, and write a plan file. Do not create or modify any source files.

---

## Step 1 — Context Gathering (delegated to code-explorer)

Use the `code-explorer` subagent to investigate the codebase. Pass it the feature description from $ARGUMENTS and ask it to map:

- Project structure — routes (`src/app/`), components, hooks, lib utilities, types
- Data fetching pattern — Server Components, TanStack Query, SWR, plain fetch?
- Auth pattern — how is authentication handled, where does session/user data live?
- Form handling — react-hook-form, Zod, server actions?
- Database/API layer — ORM (Prisma, Drizzle)? Server actions or REST routes?
- Installed shadcn/ui primitives — what's already in `src/components/ui/`?
- Existing patterns this feature can reuse — components, hooks, utilities

Do not gather context yourself. Delegate entirely to `code-explorer` and use its summary as the foundation for Steps 2 and 3.

---

## Step 2 — Feature Analysis

Using the code-explorer's findings, break the feature into discrete units of work:

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
Ordered sequence respecting dependency chains. Each step includes a verification criterion.

1. Step one (e.g., database schema)
   Done when: `pnpm prisma migrate dev` succeeds and `pnpm prisma generate` produces the typed client

2. Step two (e.g., server actions)
   Done when: calling the action from a test or the browser returns the expected shape with no TypeScript errors

3. Step three (e.g., UI component)
   Done when: component renders correctly in all states (loading, empty, error, populated) and its test passes

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
- **Every step has a "Done when:" clause.** Verification criteria must be specific and runnable, not vague ("tests pass" is not enough; "pnpm test src/components/invitations/ passes with no failures" is).
