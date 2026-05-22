# Decisions (ADRs)

Architecture Decision Records. Lighter-weight than `proposals/` — ADRs document a decision that's already been made (or is being made now), in a fixed short format.

## When to write an ADR vs a proposal

- **ADR** — a decision is being made *now*. You have ≤3 alternatives, you've picked one, and you want to capture why for the next person. ~½ page.
- **Proposal** (`docs/proposals/`) — a decision is being *worked toward*. You're still investigating, the problem isn't fully scoped, the alternatives haven't been narrowed yet. ~2-5 pages.

A proposal often graduates into one or more ADRs once decisions are made.

## Filename

`<NNN>-<short-slug>.md` where NNN is a zero-padded sequence number. Examples:

```text
docs/decisions/
├── 001-use-render-for-hosting.md
├── 002-postgres-not-supabase.md
├── 003-auth-js-v5-not-clerk.md
```

Numbers never reused; they're permanent IDs you can cite in PRs ("addresses ADR-003").

## Status lifecycle

`Proposed` → `Accepted` / `Rejected` / `Superseded by ADR-NNN`

Once Accepted, an ADR is essentially immutable. Change of mind = new ADR that supersedes the old one. The old ADR stays in the file tree with its status updated.

## Format

Use [TEMPLATE.md](TEMPLATE.md). Four sections only: Status, Context, Decision, Consequences. Keep it short.

## Why this exists alongside proposals and plans

Three different jobs, three different file shapes:

- **`docs/proposals/`** — decide *what to build*. Long-form. Architecture and direction.
- **`docs/plans/`** — decide *how to ship it this week*. Time-bounded, dated.
- **`docs/decisions/`** — decide *which choice to lock in*. Short, immutable once Accepted, citable by ID.

A proposal often graduates into one or more ADRs once the direction is settled and the specific choices are made.
