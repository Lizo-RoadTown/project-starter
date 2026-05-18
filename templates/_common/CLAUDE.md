# Working in {{PROJECT_NAME}}

Project context loaded into every Claude Code session. Keep it tight; if a rule belongs to a subsystem, move it to a subdirectory `CLAUDE.md` (e.g. `web/CLAUDE.md`, `api/CLAUDE.md`) instead of growing this file.

## The stack

| Layer | Tech |
|---|---|
| Frontend | {{FRONTEND}} |
| Backend | {{BACKEND}} |
| DB | {{DB}} |
| Auth | {{AUTH}} |
| Deploy | {{DEPLOY}} |
| MCPs | See `.mcp.json` |

## Persistent memory hierarchy

Use the right tool for the right horizon:

1. **`~/.claude/projects/<this-project>/memory/MEMORY.md` + sibling files** — auto-loaded every conversation. Project principles, user feedback, accumulated vision. Single source of truth for "things already established and not to be forgotten." Write here when something is durable across sessions.
2. **`docs/proposals/*.md`** — architectural decisions that took time to land. Every major feature gets one. Cite section numbers in PRs.
3. **`docs/plans/*.md`** — time-bounded plans dated `YYYY-MM-DD-name.md`. Active when work is in flight; archived once shipped.
4. **`docs/test-runs/*.md`** — friction-surface logs from real end-to-end runs.
5. **Git history** — every commit message explains *why*. Use it instead of reconstructing.

**Discipline:** when starting a task, check memory first (it's already loaded), then proposals (if the area was designed), then plans (if work is in flight). Only then read code. Read code with the smallest viable scope.

## Token discipline

Default: **read the smallest viable scope; never re-read what you've already loaded**.

| If you need… | Use… | Don't use… |
|---|---|---|
| To find files matching a pattern | `Glob` | `Bash ls -R` |
| To search code for a string | `Grep` with `head_limit` | `Read` on candidate file after candidate file |
| To know what a symbol means in context | `Grep -n` then `Read` with `offset` + `limit` | `Read` the whole file |
| To modify a file you've already read | `Edit` (sends only the diff) | `Write` (sends the whole new content) |
| To browse repo structure | `Glob "**/*.{md,ts,py}"` | Recursive `Read` |
| To check git state | `Bash git status --short` | `git diff` without filtering |

Avoid:
- Reading files just to confirm something obvious.
- Re-reading files within the same conversation unless they've changed.
- Reading full migration / endpoint / config files when you only need a function or block.
- Quoting long file contents in responses when a path + line range suffices.

## Skills to lean on

The Claude Code marketplace ships skills that augment what's built into the harness. Lean on these when relevant — they're already installed at the user level.

### Planning + Architecture

| Skill | When |
|---|---|
| `concise-planning` | Any non-trivial task. Produces atomic checklist (Approach / Scope / Action Items / Validation) with at most 1-2 clarifying questions. |
| `architecture-decision-records` | Use the ADR format for architectural choices, paired with `docs/proposals/`. |
| `claude-md-management` | Periodically audit + improve this CLAUDE.md file. Has a quality rubric — commands documented? architecture clear? gotchas present? |

### Iteration + Review

| Skill | When |
|---|---|
| `code-reviewer` / `code-review-excellence` | Before merging. |
| `pr-review-toolkit` | Strengthens PR descriptions and review flow. |
| `feature-dev` | New feature workflow. |
| `code-refactoring-refactor-clean` | Refactor patterns. |

### Context efficiency (critical for long sessions)

| Skill | When |
|---|---|
| `context-management-context-save` / `context-restore` | Mid-session hand-off. Save context before ending a session so the next picks up cleanly. |
| `context-compression` | When the conversation is getting long. |
| `audit-context-building` | When something feels broken about what's loaded — review the context state. |

### Meta (keep the project healthy)

| Skill | When |
|---|---|
| `skill-creator` | Build project-specific skills as the project evolves. |
| `session-report` | End-of-session summaries for hand-off. |
| `cc-skill-coding-standards` | Universal coding standards reference. |

Built-in harness capabilities (always available, no install): `EnterPlanMode` for designing before coding, `TodoWrite` for multi-step tracking, the `Agent` tool with `Explore` / `general-purpose` for delegated research.

## Voice and tone

Describe what *is*, not what it *isn't*. No marketing language ("the unlock," "delightful," "exciting"). No self-congratulation ("we built a beautiful X"). No defensive contrasts ("real X not Y"). No conversation-language in product surfaces.

Failure mode: copy that performs enthusiasm or expertise. Both are tells of insecure design.

## Commit + PR discipline

- **Small PRs.** One concern per branch. Stack only when the dependency is real.
- **Always open via `gh pr create`** with a body that includes a Test Plan checklist.
- **Cite proposals** when relevant.
- **Never `--no-verify`, never `--amend` on something already pushed.** Make a new commit.
- **Co-author tag**: `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>`.

## Environment

{{ENVIRONMENT_NOTES}}

## What to do when in doubt

1. Search memory first (already loaded — re-read MEMORY.md links if needed).
2. Search proposals (`docs/proposals/`) for the relevant subsystem.
3. If you have to read code, scope it tight: Grep first, Read with offset/limit second.
4. If you're about to make a destructive change, ask before acting.
