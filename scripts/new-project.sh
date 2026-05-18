#!/usr/bin/env bash
# new-project.sh
#
# Scaffolds a new project from one of the templates in this repo.
# Bash equivalent of new-project.ps1 for Mac, Linux, WSL, and Docker.
#
# Usage:
#   ./scripts/new-project.sh --type ui-app --name my-new-project
#   ./scripts/new-project.sh --type agent-app --name my-agent --target ~/dev
#
# What it does (matches new-project.ps1):
#   1. Creates <target>/<name>
#   2. Copies templates/_common/* into it
#   3. Copies templates/<type>/* into it (appends CLAUDE.md.extension to the base CLAUDE.md)
#   4. Find/replaces {{PROJECT_NAME}}, {{FRONTEND}}, etc. placeholders
#   5. git init + first commit

set -euo pipefail

TYPE=""
NAME=""
TARGET="$(pwd)"
FRONTEND="TBD"
BACKEND="TBD"
DB="TBD"
AUTH="TBD"
DEPLOY="TBD"
ENV_NOTES="TBD — fill in shell quirks, hosting defaults, etc."
NO_GIT=0

usage() {
  cat <<EOF
Usage: $0 --type <ui-app|agent-app> --name <project-name> [options]

Required:
  --type        ui-app | agent-app
  --name        lowercase, kebab-case (^[a-z0-9][a-z0-9-]*$)

Optional:
  --target      Parent directory (default: current dir)
  --frontend    Frontend stack description
  --backend     Backend stack description
  --db          Database description
  --auth        Auth stack description
  --deploy      Deploy target description
  --env-notes   Free-form environment notes
  --no-git      Skip git init + first commit
  -h, --help    Show this help
EOF
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type)      TYPE="$2"; shift 2 ;;
    --name)      NAME="$2"; shift 2 ;;
    --target)    TARGET="$2"; shift 2 ;;
    --frontend)  FRONTEND="$2"; shift 2 ;;
    --backend)   BACKEND="$2"; shift 2 ;;
    --db)        DB="$2"; shift 2 ;;
    --auth)      AUTH="$2"; shift 2 ;;
    --deploy)    DEPLOY="$2"; shift 2 ;;
    --env-notes) ENV_NOTES="$2"; shift 2 ;;
    --no-git)    NO_GIT=1; shift ;;
    -h|--help)   usage 0 ;;
    *)           echo "Unknown arg: $1" >&2; usage 1 ;;
  esac
done

[[ -z "$TYPE" || -z "$NAME" ]] && { echo "Error: --type and --name are required" >&2; usage 1; }
[[ "$TYPE" != "ui-app" && "$TYPE" != "agent-app" ]] && { echo "Error: --type must be ui-app or agent-app" >&2; exit 1; }
[[ ! "$NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]] && { echo "Error: --name must match ^[a-z0-9][a-z0-9-]*$" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$TARGET/$NAME"

[[ -e "$PROJECT_DIR" ]] && { echo "Error: target already exists: $PROJECT_DIR" >&2; exit 1; }

echo "Creating $PROJECT_DIR from $TYPE template..."
mkdir -p "$PROJECT_DIR"

# Copy _common (including dotfiles)
COMMON_DIR="$REPO_ROOT/templates/_common"
cp -a "$COMMON_DIR/." "$PROJECT_DIR/"

# Copy variant-specific files, excluding the .extension file
VARIANT_DIR="$REPO_ROOT/templates/$TYPE"
if [[ -d "$VARIANT_DIR" ]]; then
  # rsync if available (handles dotfiles + exclusion cleanly); fall back to find+cp
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude='CLAUDE.md.extension' "$VARIANT_DIR/" "$PROJECT_DIR/"
  else
    (cd "$VARIANT_DIR" && find . -type f ! -name 'CLAUDE.md.extension' -print0 | \
      while IFS= read -r -d '' f; do
        dest="$PROJECT_DIR/${f#./}"
        mkdir -p "$(dirname "$dest")"
        cp "$f" "$dest"
      done)
  fi
fi

# Append the variant's CLAUDE.md.extension to the base CLAUDE.md
EXT_PATH="$VARIANT_DIR/CLAUDE.md.extension"
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
if [[ -f "$EXT_PATH" && -f "$CLAUDE_MD" ]]; then
  # Strip the first line (a human-only header like "# agent-app extensions — append to ...")
  ext_body="$(tail -n +2 "$EXT_PATH")"
  printf '\n\n%s\n' "$ext_body" >> "$CLAUDE_MD"
fi

# Find/replace placeholders in text files
replace_in_file() {
  local f="$1"
  # Use a single sed pass with multiple -e clauses; portable across GNU and BSD sed via temp file
  local tmp
  tmp="$(mktemp)"
  sed \
    -e "s|{{PROJECT_NAME}}|${NAME}|g" \
    -e "s|{{FRONTEND}}|${FRONTEND}|g" \
    -e "s|{{BACKEND}}|${BACKEND}|g" \
    -e "s|{{DB}}|${DB}|g" \
    -e "s|{{AUTH}}|${AUTH}|g" \
    -e "s|{{DEPLOY}}|${DEPLOY}|g" \
    -e "s|{{ENVIRONMENT_NOTES}}|${ENV_NOTES}|g" \
    "$f" > "$tmp" && mv "$tmp" "$f"
}

while IFS= read -r -d '' f; do
  replace_in_file "$f"
done < <(find "$PROJECT_DIR" -type f \( \
    -name '*.md' -o -name '*.json' -o -name '*.tsx' -o -name '*.ts' \
    -o -name '*.py' -o -name '*.css' -o -name '*.yml' -o -name '*.yaml' \
  \) -print0)

# git init + first commit
if [[ $NO_GIT -eq 0 ]]; then
  (cd "$PROJECT_DIR" && \
    git init --initial-branch=main >/dev/null && \
    git add . && \
    git commit -m "Initial scaffold from project-starter ($TYPE)" >/dev/null)
  echo "Git initialized with first commit."
fi

cat <<EOF

Done. Next steps:
  cd $PROJECT_DIR
  # Open CLAUDE.md and fill in any TBD fields
  # Add a remote and push:
  #   gh repo create $NAME --private --source=. --push
EOF
