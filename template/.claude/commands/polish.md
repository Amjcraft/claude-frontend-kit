Run a pre-ship readiness audit on the file(s) or feature specified in $ARGUMENTS. If no argument is given, audit the current branch diff against main.

This is a Phase 3 check — run this before opening a PR. Assumes `/cleanup` has already been run.

---

Use the `pr-reviewer` subagent to run the full audit. Pass it the scope from $ARGUMENTS, or instruct it to audit "the current branch diff against main" if no argument was given.

The pr-reviewer checks: SEO, performance, visual quality, responsiveness, and test coverage. It returns a structured verdict.

Surface the verdict and priority action items to the user exactly as returned by the subagent. Do not summarize or reformat — return the full audit output.
