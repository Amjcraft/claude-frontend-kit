Read the plan at `docs/plans/$ARGUMENTS.md` and execute its Implementation Order steps one at a time, verifying each before moving to the next.

---

## Before starting

1. Read the plan file in full
2. Check the **Open Questions** section — if any items are unchecked (`[ ]`), stop here and list them. Do not proceed until every open question is resolved
3. Confirm you understand the full scope and dependency chain before writing any code

---

## For each step

Work through the Implementation Order in sequence:

1. **Announce** the step: "Starting step N — [title]"
2. **Implement** the step exactly as described in the plan — no additions, no shortcuts
3. **Verify** by running the step's "Done when:" check:
   - If it's a shell command (`pnpm ...`, `git ...`), run it and check the output
   - If it's a visual or behavioral check, describe what you observe and confirm it matches
4. **On pass** — announce "Step N complete" and move to step N+1
5. **On fail** — stop immediately and report:
   - Which step failed
   - The exact "Done when:" check that was run
   - The actual output or error
   - What you believe needs to change before retrying

Do not move to the next step until the current step's verification passes.

---

## After all steps complete

Output a summary:
- Total steps completed
- Confirmation that all "Done when:" checks passed
- Next recommended action: "Run `/cleanup [files]` then `/polish` before opening a PR"

---

## Rules

- Follow the plan's implementation order exactly — do not reorder or skip steps
- Do not implement anything not described in the plan — scope creep belongs in a new plan
- If a step's scope is unclear, ask rather than guess
- If the plan file does not exist, report the missing path and stop
