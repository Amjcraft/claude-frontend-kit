# frontend-agent-toolkit memory

## What this repo is
A reusable Claude Code configuration layer for React/Next.js/Tailwind/shadcn-ui projects.
Run `install.sh` from inside a target project to scaffold Claude Code config files.

## Stack assumptions
Next.js App Router, TypeScript (strict), Tailwind CSS, shadcn/ui, pnpm, Vitest, Playwright.
Conventional commits, squash merge to main.

## Structure
- `template/` — always-installed base files (CLAUDE.md, .mcp.json, skills, commands, agents, settings.json)
- `modules/{name}/` — optional modules: figma, playwright, vercel, storybook
  - `meta.json` — name, description, mcpScope, requiresEnv, setupPrompt
  - `mcp-entry.json` — MCP server block to merge into .mcp.json
  - `template/` — files to copy into target project

## Install flow
1. Run `bash install.sh` from inside a target project
2. Prompts for project name + description (injected into CLAUDE.md via sed)
3. Interactive module selection (reprint-on-toggle, no cursor tricks)
4. Copies template files recursively (skips existing), merges .gitignore entries
5. GitHub MCP uses Docker: prompts for PAT, exports before `claude mcp add`, unsets after
6. Module user-scoped MCPs: export token before `claude mcp add -e VAR` (no value in argv), unset after

## Key files
- `install.sh` — main installer
- `template/CLAUDE.md` — stack, commands, file structure, conventions, MCP reference, agent workflow, "When to delegate" section
- `template/.claude/settings.json` — PostToolUse hooks: prettier + eslint after Edit/Write on *.ts/*.tsx; tsc gated on CLAUDE_HOOKS_TYPECHECK=1
- `template/.claude/agents/code-explorer.md` — read-only subagent (Read, Grep, Glob); structured output: What I looked at / Key findings / Relevant files / Open questions
- `template/.claude/agents/pr-reviewer.md` — audit subagent (Read, Grep, Glob, Bash read-only); returns verdict + priority action items
- `template/.claude/commands/plan.md` — delegates Step 1 to code-explorer; plan template requires "Done when:" per step
- `template/.claude/commands/execute-plan.md` — reads docs/plans/$ARGUMENTS.md, walks steps, runs Done when: checks, stops on failure
- `template/.claude/commands/polish.md` — delegates entirely to pr-reviewer
- `template/.claude/commands/investigate.md` — one-liner wrapper around code-explorer
- `template/.claude/commands/cleanup.md` — Phase 2: a11y, motion, design system, code quality, semantic HTML
- `template/.claude/commands/generate-component.md` — Phase 1 scaffold helper
- `template/.claude/skills/component-patterns/SKILL.md` — has name:; trimmed to ~75 lines (project-specific rules only)
- `template/.claude/skills/project-conventions/SKILL.md` — has name:
- `template/AI-TOOLING-SETUP.md` — full teammate onboarding doc with hooks, commands, agents, subagents tables

## Module skills (all have name: frontmatter)
- `modules/figma/template/.claude/skills/figma-design/SKILL.md`
- `modules/playwright/template/.claude/skills/e2e-testing/SKILL.md`
- `modules/storybook/template/.claude/skills/storybook/SKILL.md` — has activation.globs for *.stories.tsx and src/components/ui/**/*.tsx
- Vercel: skill REMOVED, replaced with `modules/vercel/template/.claude/commands/deploy-check.md`

## GitHub MCP (corrected in P0)
Uses Docker: `claude mcp add --scope user github -e GITHUB_PERSONAL_ACCESS_TOKEN -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server`
Requires Docker + GitHub PAT. NOT npx-based, NOT token-free.

## Phased workflow
- Phase 0: /plan — delegates context gathering to code-explorer subagent, writes docs/plans/[feature].md
- Phase 1: /execute-plan [name] — walks plan step by step with Done when: verification
- Phase 1 (always-on): component-patterns + project-conventions skills
- Phase 2: /cleanup — inline per-file audit
- Phase 3: /polish — delegates to pr-reviewer subagent

## TODO / future
- GitHub Actions for linting/testing the install script
- Per-module README files
- --update flag for install.sh to add new files without overwriting customized ones
- Possibly publish install script as a remote curl target once on GitHub

# currentDate
Today's date is 2026-05-07.
