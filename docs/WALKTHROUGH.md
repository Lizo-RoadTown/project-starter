# Walkthrough — scaffolding your first project

Start-to-finish hands-on. Five minutes from clone to first commit in a new repo.

## Prerequisites

| Tool | Why | Check |
|---|---|---|
| Git | Clone this repo, init the new one | `git --version` |
| PowerShell 7+ **or** Bash | Run the scaffolder | `pwsh --version` or `bash --version` |
| GitHub CLI (`gh`) | Push the new project to GitHub | `gh --version` |
| Claude Code | Open the scaffolded project | `claude --version` |

PowerShell + Bash are both supported — pick whichever your shell has. Windows users get PowerShell preinstalled; Mac/Linux users use the Bash script or [run the scaffolder in Docker](DOCKER.md).

## 1. Clone this repo

```powershell
git clone https://github.com/Lizo-RoadTown/project-starter
cd project-starter
```

You'll see:

```
CONTRIBUTING.md   docs/   LICENSE   README.md   scripts/   templates/
```

## 2. Scaffold a new project

Pick a variant — `ui-app` or `agent-app` — and a target directory.

### PowerShell

```powershell
./scripts/new-project.ps1 `
  -Type ui-app `
  -Name my-new-website `
  -Target C:\dev `
  -Frontend "Next.js 16, React 19, Tailwind v4" `
  -Backend "FastAPI" `
  -DB "Postgres on Render" `
  -Auth "Auth.js v5" `
  -Deploy "Render"
```

### Bash

```bash
./scripts/new-project.sh \
  --type ui-app \
  --name my-new-website \
  --target ~/dev \
  --frontend "Next.js 16, React 19, Tailwind v4" \
  --backend "FastAPI" \
  --db "Postgres on Render" \
  --auth "Auth.js v5" \
  --deploy "Render"
```

What it does, in order:

1. Creates `<Target>/<Name>/` (errors if it already exists — won't clobber)
2. Copies `templates/_common/*` in
3. Copies `templates/<Type>/*` in (excluding the `.extension` file)
4. Appends `templates/<Type>/CLAUDE.md.extension` to the base `CLAUDE.md`
5. Replaces `{{PROJECT_NAME}}`, `{{FRONTEND}}`, `{{BACKEND}}`, `{{DB}}`, `{{AUTH}}`, `{{DEPLOY}}`, `{{ENVIRONMENT_NOTES}}` everywhere
6. Runs `git init --initial-branch=main` and makes the first commit

Output ends with the next-steps hint:

```
Done. Next steps:
  cd C:\dev\my-new-website
  # Open CLAUDE.md and fill in any TBD fields
  # Add a remote and push:
  #   gh repo create my-new-website --private --source=. --push
```

## 3. Inspect what you got

```powershell
cd C:\dev\my-new-website
ls
```

| File | Role |
|---|---|
| `CLAUDE.md` | Loaded into every Claude Code session. Stack table + token discipline + skills + voice rules + commit/PR rules. Variant-specific sections appended. |
| `.mcp.json` | MCP servers pinned to this project — Serena (semantic code retrieval), Context7 (library docs), GitHub. |
| `.gitignore` | Standard ignore list — `node_modules`, `.env`, build artifacts, OS junk, coverage. |
| `docs/proposals/` | Empty except a README + TEMPLATE.md. Add proposals here for architectural decisions before coding. |
| `docs/plans/` | Empty except a README + TEMPLATE.md. Add `YYYY-MM-DD-name.md` plans for in-flight work. |
| `docs/test-runs/` | Empty except a README. Real end-to-end run logs go here. |
| `docs/UX_CONTRACT.md` | UI variant only. The discipline every UI PR passes. |

Open `CLAUDE.md` and fill in any remaining `TBD` fields — usually just `{{ENVIRONMENT_NOTES}}` if you didn't pass it as a flag.

## 4. Install the skills your `CLAUDE.md` references

Your scaffolded `CLAUDE.md` references skills and plugins (`ui-ux-pro-max`, `frontend-design`, `claude-api`, etc.) that aren't installed by default. Skills live at `~/.claude/skills/` — **one-time per computer**.

```powershell
# From the project-starter folder (not your new project):
./scripts/install-skills.ps1 -Variant ui-app   # or agent-app, or both
```

```bash
# Mac/Linux/WSL equivalent:
./scripts/install-skills.sh --variant ui-app
```

What it does:

- **Auto-installs** the shell-installable pieces: `ui-ux-pro-max` (via npm), `design-system` (git clone), `agent-memory-systems` (git clone + symlink).
- **Prints** the `/plugin install …` commands for the Claude Code marketplace plugins (`frontend-design`, `claude-api`, `ralph-loop`, `multi-agent-patterns`). You'll paste those into your Claude Code session after step 6.

Your scaffolded project also has a `SKILLS.md` at its root with the full list and source URLs. See [docs/marketplace-and-plugins](../site/docs/marketplace-and-plugins.html) for the full breakdown of marketplaces and the `/plugin` command surface.

## 5. Push to GitHub

```powershell
gh repo create my-new-website --private --source=. --push
```

That creates a new private repo under your GitHub account, sets the remote, and pushes the initial commit.

## 6. Open in Claude Code

```powershell
claude .
```

On first open, Claude Code reads `CLAUDE.md` and connects to the MCP servers listed in `.mcp.json`. You'll be prompted to authorize the GitHub MCP server (one-time, OAuth) and to allow Serena to run (it'll spawn `uvx` to fetch the latest version).

After that, every session starts with:
- The full `CLAUDE.md` loaded as context
- Serena / Context7 / GitHub MCP servers available
- Auto-memory at `~/.claude/projects/<this-project>/memory/MEMORY.md` building up across sessions

## 7. Finish the plugin install inside Claude Code

Paste the `/plugin install …` commands that `install-skills` printed in step 4. Example for UI App:

```text
/plugin marketplace add anthropics/claude-plugins-official
/plugin install frontend-design
```

Run `/plugin list` first to skip anything already bundled with your Claude Code install. Then ask Claude *"Which of the skills referenced in CLAUDE.md do you have installed?"* to verify nothing's missing.

## What to do next

- **Before coding the first feature**, write a proposal in `docs/proposals/` so the architecture is captured before implementation drifts.
- **Read [docs/AGENTS.md](AGENTS.md)** to know which MCP servers and Claude Code skills the templates expect you to lean on.
- **Bookmark the [UX Contract](../templates/ui-app/docs/UX_CONTRACT.md)** (UI projects) — every UI PR cites it.

## Common issues

| Symptom | Fix |
|---|---|
| `Target directory already exists` | The script refuses to overwrite. Either delete the dir, pick a new name, or pick a new `-Target`. |
| `Set-ExecutionPolicy` blocks the script on Windows | Run once: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`. |
| `uvx` not found when Serena tries to start | Install [uv](https://github.com/astral-sh/uv): `winget install astral-sh.uv` (Windows) or `curl -LsSf https://astral.sh/uv/install.sh \| sh` (Mac/Linux). |
| GitHub MCP server fails to authorize | Run `gh auth login` first so the CLI is authenticated; the MCP server reuses that token. |
| Don't have PowerShell + don't want to install it | Use the [Docker route](DOCKER.md) or the Bash script. |
