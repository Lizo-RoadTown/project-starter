#project-starter

Day-1 scaffolding for new projects worked on with Claude Code. Captures the lessons learned about keeping token usage low, accuracy high, and architecture decisions visible across sessions.

## What this is

A repository of project templates. Each variant ships with:

- **`CLAUDE.md`** — project context loaded into every Claude Code session. Sets the stack, persistent-memory hierarchy, token discipline, skills to lean on, voice rules, commit/PR discipline.
- **`.mcp.json`** — project-pinned MCP servers. Serena (semantic code retrieval), Context7 (library docs), GitHub.
- **`docs/`** skeleton — `proposals/`, `plans/`, `test-runs/` with READMEs explaining their roles, plus templates.
- **`.gitignore`** — sensible defaults.
- **`docs/UX_CONTRACT.md`** (UI variants only) — the design discipline every UI PR passes.

## Variants

| Variant | For | Adds on top of `_common` |
|---|---|---|
| `ui-app` | Next.js / consumer web / dashboards | `ui-ux-pro-max`, `design-system`, `onboarding-psychologist`, `frontend-design` skill refs + UX_CONTRACT.md |
| `agent-app` | LLM agents / AI assistants / Claude-API apps | `ai-agents-architect`, `agent-memory-systems`, `agent-orchestrator`, `claude-api` skill refs + runtime discipline notes |

More variants (api-service, library, …) can be added — see [CONTRIBUTING.md](CONTRIBUTING.md).

## Usage

### Quick path — copy with the script

```powershell
git clone https://github.com/{{YOUR-ORG}}/claude-project-starter
cd claude-project-starter

# Scaffold a UI app:
./scripts/new-project.ps1 -Type ui-app -Name my-website -Target C:\dev `
  -Frontend "Next.js 16, React 19, Tailwind v4" `
  -Backend "FastAPI" -DB "Postgres on Render" `
  -Auth "Auth.js v5" -Deploy "Vercel"

# Scaffold an agent app:
./scripts/new-project.ps1 -Type agent-app -Name my-agent-app -Target C:\dev `
  -Backend "FastAPI + deepagents" -DB "Postgres + LanceDB"
```

The script copies `_common` + the chosen variant, fills in placeholders, runs `git init`, makes the first commit. Then you `gh repo create` to push to GitHub.

### Manual path — clone + copy by hand

```powershell
git clone https://github.com/{{YOUR-ORG}}/claude-project-starter temp-starter
mkdir my-new-project
Copy-Item -Path "temp-starter/templates/_common/*" -Destination my-new-project/ -Recurse
Copy-Item -Path "temp-starter/templates/ui-app/*" -Destination my-new-project/ -Recurse
# Append CLAUDE.md.extension to CLAUDE.md, edit placeholders, then:
cd my-new-project
git init && git add . && git commit -m "Initial scaffold"
```

## Why this exists

Working with Claude Code across many projects revealed a few patterns that compound:

1. **Auto-memory + proposals + UX_CONTRACT** is the right persistence triad. Auto-memory carries voice rules and accumulated principles across sessions. Proposals capture architectural decisions deliberately. UX_CONTRACT gates user-facing surfaces. Each layer is cheap to maintain; together they keep agents consistent.

2. **Token discipline matters more as projects grow.** Reading whole files when symbols suffice, re-reading files already loaded, quoting code back to the user — these add up. CLAUDE.md codifies the discipline so every agent inherits it.

3. **Serena (LSP-backed semantic code retrieval) is the single biggest in-session token saver** for code work. Pinned in `.mcp.json` so every new project has it from day one.

4. **Skills already exist for most things.** The Claude Code marketplace has skills for planning, review, refactoring, context management. CLAUDE.md references them so future agents on the project use them instead of improvising.

## Maintained by

[Liz / Lizo-RoadTown](https://github.com/Lizo-RoadTown). Started in May 2026 as a distillation of patterns from the [Make_Skills](https://github.com/Lizo-RoadTown/Make_Skills) project.

Contributions welcome — new variants, refinements to CLAUDE.md, skill recommendations as the marketplace evolves. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Apache 2.0 — see [LICENSE](LICENSE).
