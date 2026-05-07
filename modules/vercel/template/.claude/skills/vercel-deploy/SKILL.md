---
name: vercel-deploy
description: Vercel deployment — automatic deploy workflow, env var management via CLI, Vercel MCP usage, common build failure and env mismatch troubleshooting
---

# Vercel Deployment

Guidance for managing deployments and environment configuration via Vercel.

## Deployment Workflow

This project deploys automatically via Vercel's GitHub integration:
- **Push to `main`** → production deployment
- **Open PR** → preview deployment (URL posted to PR)
- **Merge PR** → triggers new production deployment

## Environment Variables

Manage env vars through Vercel dashboard or CLI — never commit secrets.

```bash
# Add or update a variable
vercel env add VARIABLE_NAME

# Pull env vars to local .env.local for development
vercel env pull .env.local

# List all variables
vercel env ls
```

Environments: `production`, `preview`, `development`

## Using the Vercel MCP

With the Vercel MCP connected, you can ask Claude Code to:
- Check deployment status: "What's the current production deployment status?"
- View deployment logs: "Show me the build logs for the latest deployment"
- Manage environment variables: "Add the DATABASE_URL env var to production"
- Inspect deployments: "List the last 5 deployments"

## Common Issues

### Build Failures
1. Check build logs in Vercel dashboard or via MCP
2. Verify all env vars are set in Vercel (not just `.env.local`)
3. Check `next.config.js` — Vercel-incompatible settings (e.g., `output: 'export'` with dynamic routes)

### Environment Mismatch
- Local uses `.env.local`, Vercel uses dashboard-configured vars
- Run `vercel env pull` to sync
- `NEXT_PUBLIC_` vars must be set at build time — changing them requires a new deployment

### Preview vs Production
- Preview deployments use `preview` env vars
- Useful for testing with staging databases/APIs before merging
