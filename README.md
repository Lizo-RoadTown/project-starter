# project-starter

<p align="center">
  <img src="site/assets/project-starter-doorway.jpg" alt="A dark room with a slightly-open doorway on the right, warm amber light spilling onto a polished floor — the entry point for a new project." width="800">
</p>

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

Three ways to scaffold — pick the one that matches your shell. All three produce the same output.

### PowerShell (Windows default)

```powershell
git clone https://github.com/Lizo-RoadTown/project-starter
cd project-starter

# Scaffold a UI app:
./scripts/new-project.ps1 -Type ui-app -Name my-website -Target C:\dev `
  -Frontend "Next.js 16, React 19, Tailwind v4" `
  -Backend "FastAPI" -DB "Postgres on Render" `
  -Auth "Auth.js v5" -Deploy "Render"

# Scaffold an agent app:
./scripts/new-project.ps1 -Type agent-app -Name my-agent-app -Target C:\dev `
  -Backend "FastAPI + deepagents" -DB "Postgres + LanceDB"
```

### Bash (Mac, Linux, WSL)

```bash
git clone https://github.com/Lizo-RoadTown/project-starter
cd project-starter

./scripts/new-project.sh --type ui-app --name my-website --target ~/dev \
  --frontend "Next.js 16, React 19, Tailwind v4" \
  --backend "FastAPI" --db "Postgres on Render" \
  --auth "Auth.js v5" --deploy "Render"
```

### Docker (no PowerShell, no shell preference, fully reproducible)

```bash
docker build -t project-starter .
mkdir -p out
docker run --rm -v "$(pwd)/out:/out" project-starter \
  --type ui-app --name my-website --target /out \
  --frontend "Next.js 16" --backend "FastAPI"
```

See [docs/DOCKER.md](docs/DOCKER.md) for compose, environment variables, and Windows path quoting.

---

All three scripts copy `_common` + the chosen variant, fill placeholders, run `git init`, and commit. Then you `gh repo create` to push to GitHub.

## Documentation

- **[docs/WALKTHROUGH.md](docs/WALKTHROUGH.md)** — hands-on, five-minute first scaffold with concrete output and common-issue fixes.
- **[docs/AGENTS.md](docs/AGENTS.md)** — what each MCP server does, what skills the templates reference, and how the layers fit together.
- **[docs/DOCKER.md](docs/DOCKER.md)** — running the scaffolder in a container.
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — how to add a new variant or refine `_common`.

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
