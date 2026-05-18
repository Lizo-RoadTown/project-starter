# Proposals

Architectural decisions for this project. Every major feature, every significant change to data model or runtime, gets a proposal *before* code.

## Workflow

1. Copy `TEMPLATE.md` to `YYYY-MM-DD-short-name.md` (or just `short-name.md` if it'll live long).
2. Write the proposal. The Problem → Decision → Migration path skeleton is non-negotiable; everything else is optional.
3. Open a PR with `Status: Open`.
4. Review, iterate. Status moves to `Accepted` when the PR merges.
5. Implementation PRs cite the proposal by section.
6. If a later proposal replaces this one, mark `Status: Superseded` and link forward.

## Why proposals before code

- Architecture decisions made in PR comments get lost. Proposals are searchable.
- Future agents on this project see the *why*, not just the *what*.
- Pre-coding alignment catches misunderstandings before they cost work.

## What's NOT a proposal

- Bug fixes — just open a PR.
- Refactors that don't change behavior or interface — just open a PR.
- Small features that are obviously the right shape — just open a PR.

Use judgment. If you're not sure whether something needs a proposal, the answer is probably no. Save proposals for architecture-level decisions.
