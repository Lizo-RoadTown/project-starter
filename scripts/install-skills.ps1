# install-skills.ps1
#
# Installs the shell-installable skills referenced by project-starter templates.
# Run AFTER scaffolding a project. Skills install at the user level
# (~/.claude/skills/), so this is one-time per machine.
#
# Usage:
#   ./scripts/install-skills.ps1 -Variant ui-app
#   ./scripts/install-skills.ps1 -Variant agent-app
#   ./scripts/install-skills.ps1 -Variant both
#
# What it does AUTOMATICALLY (uses npm, pip, git):
#   - ui-ux-pro-max (npm)
#   - design-system / triptease (git clone)
#   - agent-memory-systems (git clone)
#
# What it CAN'T install (must be done inside Claude Code with /plugin):
#   - frontend-design (Anthropic plugin)
#   - claude-api (Anthropic plugin)
#   - ralph-loop (Anthropic plugin)
#   - multi-agent-patterns / context-engineering (community plugin)
#
# Those are printed at the end as copy-paste commands you run from inside
# your Claude Code session.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ui-app", "agent-app", "both")]
    [string]$Variant,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$SkillsDir = Join-Path $env:USERPROFILE ".claude\skills"

function Write-Section($text) {
    Write-Host ""
    Write-Host "==== $text ====" -ForegroundColor Cyan
}

function Write-Step($text) {
    Write-Host ">>> $text" -ForegroundColor Yellow
}

function Invoke-Step {
    param(
        [string]$Description,
        [scriptblock]$Command
    )
    Write-Step $Description
    if ($DryRun) {
        Write-Host "    [DRY RUN] $Command" -ForegroundColor DarkGray
        return
    }
    try {
        & $Command
        Write-Host "    OK" -ForegroundColor Green
    } catch {
        Write-Host "    FAILED: $_" -ForegroundColor Red
    }
}

# Make sure ~/.claude/skills/ exists
if (-not (Test-Path $SkillsDir)) {
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

# ============================================================
# UI APP
# ============================================================
function Install-UIApp {
    Write-Section "Installing UI App skills"

    # 1. ui-ux-pro-max
    Invoke-Step -Description "ui-ux-pro-max: install uipro CLI" -Command {
        npm install -g uipro-cli
    }
    Invoke-Step -Description "ui-ux-pro-max: initialize for Claude" -Command {
        uipro init --ai claude
    }

    # 2. design-system (triptease)
    $designSystemDir = Join-Path $SkillsDir "design-system"
    if (Test-Path $designSystemDir) {
        Write-Step "design-system: already cloned, skipping"
    } else {
        Invoke-Step -Description "design-system: clone Triptease's implementation" -Command {
            git clone https://github.com/triptease/claude-skill-design-system $designSystemDir
        }
    }
}

# ============================================================
# AGENT APP
# ============================================================
function Install-AgentApp {
    Write-Section "Installing Agent App skills"

    # 3. agent-memory-systems
    $memoryRepoDir = Join-Path $SkillsDir "antigravity-awesome-skills"
    $memoryLinkDir = Join-Path $SkillsDir "agent-memory-systems"

    if (Test-Path $memoryRepoDir) {
        Write-Step "agent-memory-systems: repo already cloned"
    } else {
        Invoke-Step -Description "agent-memory-systems: clone antigravity-awesome-skills" -Command {
            git clone https://github.com/sickn33/antigravity-awesome-skills $memoryRepoDir
        }
    }
    if (Test-Path $memoryLinkDir) {
        Write-Step "agent-memory-systems: symlink already exists"
    } else {
        Invoke-Step -Description "agent-memory-systems: create symlink" -Command {
            $target = Join-Path $memoryRepoDir "plugins\antigravity-awesome-skills-claude\skills\agent-memory-systems"
            New-Item -ItemType SymbolicLink -Path $memoryLinkDir -Target $target | Out-Null
        }
    }
}

# Run requested variants
if ($Variant -in @("ui-app", "both"))    { Install-UIApp }
if ($Variant -in @("agent-app", "both")) { Install-AgentApp }

# ============================================================
# Manual install reminder for Claude Code marketplace plugins
# ============================================================
Write-Section "Plugins to install from inside Claude Code"
Write-Host @"

Open Claude Code in your project, then paste these commands into the Claude
Code session (NOT this terminal). These plugins live in the Claude Code
marketplace and can only be installed from there.

"@

if ($Variant -in @("ui-app", "both")) {
    Write-Host "UI App:" -ForegroundColor Cyan
    Write-Host "  /plugin marketplace add anthropics/claude-plugins-official"
    Write-Host "  /plugin install frontend-design"
    Write-Host ""
}
if ($Variant -in @("agent-app", "both")) {
    Write-Host "Agent App:" -ForegroundColor Cyan
    Write-Host "  /plugin marketplace add anthropics/skills"
    Write-Host "  /plugin install claude-api@anthropic-agent-skills"
    Write-Host ""
    Write-Host "  /plugin marketplace add anthropics/claude-plugins-official"
    Write-Host "  /plugin install ralph-loop"
    Write-Host ""
    Write-Host "  /plugin marketplace add muratcankoylan/Agent-Skills-for-Context-Engineering"
    Write-Host "  /plugin install multi-agent-patterns@context-engineering"
    Write-Host ""
}

Write-Host "Many of these may already be bundled with Claude Code (depends on" -ForegroundColor DarkGray
Write-Host "your install method). Run /plugin list first to see what you have." -ForegroundColor DarkGray
Write-Host ""

Write-Section "Done"
Write-Host "For full details on each skill, see your project's SKILLS.md."
