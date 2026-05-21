# Running the scaffolder in Docker

Why: you don't want to install PowerShell, Bash isn't your shell, or you want guaranteed-reproducible output across machines. The container ships with the exact toolchain the scaffolder needs and writes its output to a bind-mounted directory on your host.

The container *only* runs the scaffolder — it doesn't build, run, or test your scaffolded project. After scaffolding, you `cd` into the output directory on your host and work normally.

## Prerequisites

- Docker Desktop (Windows / Mac) or Docker Engine (Linux). Compose v2 ships with both.

## One-time build

From the repo root:

```bash
docker build -t project-starter .
```

Or with compose:

```bash
docker compose build
```

The image is ~80 MB (Debian slim + git + rsync + bash). Rebuilds are fast — the templates and scripts copy in a single layer.

## Scaffold a new project

### With `docker run`

```bash
mkdir -p out
docker run --rm \
  -v "$(pwd)/out:/out" \
  -e GIT_AUTHOR_NAME="Liz Osborn" \
  -e GIT_AUTHOR_EMAIL="liz@example.com" \
  project-starter \
    --type ui-app \
    --name my-new-site \
    --target /out \
    --frontend "Next.js 16, React 19, Tailwind v4" \
    --backend "FastAPI" \
    --db "Postgres on Render" \
    --auth "Auth.js v5" \
    --deploy "Render"
```

Your new project ends up at `./out/my-new-site/` on the host. The initial commit is attributed to whatever `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` you passed.

### With docker compose

```bash
docker compose run --rm scaffold \
  --type ui-app \
  --name my-new-site \
  --target /out \
  --frontend "Next.js 16" \
  --backend "FastAPI"
```

Compose handles the bind mount and env vars from `docker-compose.yml`. Set `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` in a `.env` file next to `docker-compose.yml` to attribute commits to you by default.

### Windows PowerShell — path quoting

`$(pwd)` doesn't expand the same way under PowerShell. Use:

```powershell
docker run --rm `
  -v "${PWD}/out:/out" `
  project-starter `
    --type ui-app --name my-new-site --target /out
```

## After scaffolding

The output directory has its own git repo (committed by the container). Two more steps before Claude Code is fully equipped.

### 1. Install the skills your `CLAUDE.md` references — on your host, not in the container

The container scaffolds the project, but skills install at the **user level** on your host machine (`~/.claude/skills/`) where Claude Code actually runs. So you run `install-skills` on the host after the container exits:

```bash
# From the project-starter repo on your host:
./scripts/install-skills.sh --variant ui-app   # or agent-app, or both
```

Auto-installs the shell-installable pieces (`ui-ux-pro-max` via npm, `design-system` and `agent-memory-systems` via git clone). Then prints the `/plugin install …` commands for the Claude Code marketplace plugins you'll run from inside Claude Code.

Your scaffolded project also has a `SKILLS.md` at its root listing everything.

### 2. Push to GitHub

```bash
cd out/my-new-site
gh repo create my-new-site --private --source=. --push
```

`gh` runs on your host, not in the container — it needs your local credentials.

## Common issues

| Symptom | Fix |
|---|---|
| `Permission denied` writing to `./out` | The container writes as UID 0 by default. On Linux, either pre-create `./out` with the right perms or run with `--user "$(id -u):$(id -g)"`. |
| Initial commit is attributed to `project-starter@local` | Pass `-e GIT_AUTHOR_NAME=... -e GIT_AUTHOR_EMAIL=...`, or set them in your shell / `.env` before `docker compose run`. |
| `target already exists` | `./out/my-new-site` already has files. Either pick a new `--name`, delete the existing dir, or use a different `--target`. |
| Container output is fine but I want to inspect the templates | `docker compose run --rm --entrypoint bash scaffold` drops you into a shell at `/starter`. |

## What the container does NOT include

By design:

- No Node, no Python, no language runtimes — your scaffolded project picks those.
- No `gh` CLI — runs on your host so it can use your auth.
- No Claude Code — runs on your host where your MCP servers, skills, and auto-memory live.
- No skill installer — `install-skills.sh` also runs on your host (skills install to `~/.claude/skills/`, not into the container).
- No editor — you open the scaffolded project in your usual editor / Claude Code session on the host.

The container has one job: run `new-project.sh` reproducibly. Everything that has to live on your machine across sessions stays on your machine.
