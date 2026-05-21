#!/usr/bin/env bash
# install-skills.sh
#
# Installs the shell-installable skills referenced by project-starter templates.
# Run AFTER scaffolding a project. Skills install at the user level
# (~/.claude/skills/), so this is one-time per machine.
#
# Usage:
#   ./scripts/install-skills.sh --variant ui-app
#   ./scripts/install-skills.sh --variant agent-app
#   ./scripts/install-skills.sh --variant both [--dry-run]
#
# What it does AUTOMATICALLY:
#   - ui-ux-pro-max (npm)
#   - design-system / triptease (git clone)
#   - agent-memory-systems (git clone + symlink)
#
# What it CAN'T install (must be done inside Claude Code with /plugin):
#   - frontend-design, claude-api, ralph-loop, multi-agent-patterns
# Those are printed at the end as copy-paste commands.

set -euo pipefail

VARIANT=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --variant)  VARIANT="$2"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//' | head -25
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

case "$VARIANT" in
  ui-app|agent-app|both) ;;
  *) echo "Error: --variant must be ui-app, agent-app, or both" >&2; exit 1 ;;
esac

SKILLS_DIR="${HOME}/.claude/skills"
mkdir -p "$SKILLS_DIR"

C_CYAN=$'\033[1;36m'
C_YELLOW=$'\033[1;33m'
C_GREEN=$'\033[1;32m'
C_RED=$'\033[1;31m'
C_GRAY=$'\033[2m'
C_RESET=$'\033[0m'

section() { printf '\n%s==== %s ====%s\n' "$C_CYAN" "$1" "$C_RESET"; }
step()    { printf '%s>>> %s%s\n' "$C_YELLOW" "$1" "$C_RESET"; }
ok()      { printf '    %sOK%s\n' "$C_GREEN" "$C_RESET"; }
fail()    { printf '    %sFAILED: %s%s\n' "$C_RED" "$1" "$C_RESET"; }

run() {
  local desc="$1"; shift
  step "$desc"
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '    %s[DRY RUN] %s%s\n' "$C_GRAY" "$*" "$C_RESET"
    return 0
  fi
  if "$@"; then ok; else fail "$*"; fi
}

install_ui_app() {
  section "Installing UI App skills"

  # 1. ui-ux-pro-max
  run "ui-ux-pro-max: install uipro CLI" npm install -g uipro-cli
  run "ui-ux-pro-max: initialize for Claude" uipro init --ai claude

  # 2. design-system (triptease)
  if [[ -d "$SKILLS_DIR/design-system" ]]; then
    step "design-system: already cloned, skipping"
  else
    run "design-system: clone Triptease's implementation" \
      git clone https://github.com/triptease/claude-skill-design-system "$SKILLS_DIR/design-system"
  fi
}

install_agent_app() {
  section "Installing Agent App skills"

  # 3. agent-memory-systems
  local memory_repo="$SKILLS_DIR/antigravity-awesome-skills"
  local memory_link="$SKILLS_DIR/agent-memory-systems"

  if [[ -d "$memory_repo" ]]; then
    step "agent-memory-systems: repo already cloned"
  else
    run "agent-memory-systems: clone antigravity-awesome-skills" \
      git clone https://github.com/sickn33/antigravity-awesome-skills "$memory_repo"
  fi

  if [[ -L "$memory_link" || -d "$memory_link" ]]; then
    step "agent-memory-systems: symlink already exists"
  else
    local target="$memory_repo/plugins/antigravity-awesome-skills-claude/skills/agent-memory-systems"
    run "agent-memory-systems: create symlink" ln -s "$target" "$memory_link"
  fi
}

[[ "$VARIANT" == "ui-app"    || "$VARIANT" == "both" ]] && install_ui_app
[[ "$VARIANT" == "agent-app" || "$VARIANT" == "both" ]] && install_agent_app

section "Plugins to install from inside Claude Code"
cat <<EOF

Open Claude Code in your project, then paste these commands into the Claude
Code session (NOT this terminal). These plugins live in the Claude Code
marketplace and can only be installed from there.

EOF

if [[ "$VARIANT" == "ui-app" || "$VARIANT" == "both" ]]; then
  printf '%sUI App:%s\n' "$C_CYAN" "$C_RESET"
  echo "  /plugin marketplace add anthropics/claude-plugins-official"
  echo "  /plugin install frontend-design"
  echo
fi

if [[ "$VARIANT" == "agent-app" || "$VARIANT" == "both" ]]; then
  printf '%sAgent App:%s\n' "$C_CYAN" "$C_RESET"
  echo "  /plugin marketplace add anthropics/skills"
  echo "  /plugin install claude-api@anthropic-agent-skills"
  echo
  echo "  /plugin marketplace add anthropics/claude-plugins-official"
  echo "  /plugin install ralph-loop"
  echo
  echo "  /plugin marketplace add muratcankoylan/Agent-Skills-for-Context-Engineering"
  echo "  /plugin install multi-agent-patterns@context-engineering"
  echo
fi

printf '%sMany of these may already be bundled with Claude Code (depends on\n' "$C_GRAY"
printf 'your install method). Run /plugin list first to see what you have.%s\n\n' "$C_RESET"

section "Done"
echo "For full details on each skill, see your project's SKILLS.md."
