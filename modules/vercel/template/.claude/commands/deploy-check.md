Use the Vercel MCP to verify this branch is ready to deploy. Check the following and report on each:

1. **Recent deploy status** — What is the current production deployment status? Any build failures or errors in the last 3 deployments?

2. **Preview deployment** — Does a preview deployment exist for the current branch? Is it healthy?

3. **Environment variable parity** — Compare env vars between production and preview environments. Flag any vars that exist in production but are missing from preview, or vice versa. Note any `NEXT_PUBLIC_` vars that would require a redeploy to take effect.

4. **Branch deployability** — Is the current branch set up to deploy? Any configuration issues in Vercel that would block a successful production deploy?

---

Output a summary with a go/no-go verdict: **Ready to deploy** ✅ or **Blocked** ❌, with specific issues and recommended fixes for anything blocking.
