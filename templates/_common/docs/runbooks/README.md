# Runbooks

Operational guides. "How to do <recurring thing>" — written so that the next person (or the on-call you in three months) can execute without re-deriving the steps.

## What belongs here

- **Deploys:** how to ship a new release, including pre-flight checks and rollback
- **Migrations:** how to run schema changes safely in dev/staging/prod
- **Incident response:** when X breaks, here's how to diagnose and fix
- **Onboarding:** how a new contributor gets a working local env
- **Routine maintenance:** dependency updates, secret rotation, backups

## What doesn't belong here

- One-off investigations → go in `docs/test-runs/`
- Architectural decisions → go in `docs/decisions/` or `docs/proposals/`
- API documentation → put it next to the code that implements it
- User-facing documentation → put it in your `site/` or a docs portal

## Filename

`<topic>.md` — kebab-case, no dates. Runbooks evolve over time; they're not historical artifacts.

```text
docs/runbooks/
├── deploy-to-render.md
├── rotate-database-credentials.md
├── investigate-failed-deploy.md
├── new-contributor-onboarding.md
```

## Format

No strict template. Suggested sections:

1. **When to use this runbook** — what trigger or symptom does it address
2. **Prerequisites** — what access, tools, or context you need
3. **Steps** — numbered, atomic, copy-pasteable
4. **Verification** — how you know it worked
5. **If it fails** — common failure modes and what to do
6. **Last verified** — date you last ran this end-to-end

Runbooks rot fast when the system changes. Each runbook owns its own freshness — note the last-verified date and re-verify after big changes.
