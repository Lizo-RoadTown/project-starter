# new-project.ps1
#
# Scaffolds a new project from one of the templates in this repo.
#
# Usage:
#   ./scripts/new-project.ps1 -Type ui-app -Name my-new-project
#   ./scripts/new-project.ps1 -Type agent-app -Name my-agent -Target C:\dev
#
# What it does:
#   1. Creates a new directory at <Target>\<Name>
#   2. Copies templates/_common/* into it
#   3. Copies templates/<Type>/* into it (appends CLAUDE.md.extension to the base CLAUDE.md)
#   4. Find/replaces {{PROJECT_NAME}}, {{FRONTEND}}, etc. placeholders
#   5. git init + first commit

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("ui-app", "agent-app")]
    [string]$Type,

    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[a-z0-9][a-z0-9-]*$")]
    [string]$Name,

    [string]$Target = (Get-Location).Path,

    [string]$Frontend = "TBD",
    [string]$Backend = "TBD",
    [string]$DB = "TBD",
    [string]$Auth = "TBD",
    [string]$Deploy = "TBD",
    [string]$EnvironmentNotes = "TBD — fill in PowerShell quirks, hosting defaults, etc.",

    [switch]$NoGit
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$projectDir = Join-Path $Target $Name

if (Test-Path $projectDir) {
    throw "Target directory already exists: $projectDir"
}

Write-Host "Creating $projectDir from $Type template..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

# Copy _common
$commonDir = Join-Path $repoRoot "templates\_common"
Copy-Item -Path "$commonDir\*" -Destination $projectDir -Recurse -Force

# Copy variant-specific files (excluding the .extension file — handled below)
$variantDir = Join-Path $repoRoot "templates\$Type"
Get-ChildItem -Path $variantDir -Recurse -Force | Where-Object {
    $_.Name -ne "CLAUDE.md.extension"
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($variantDir.Length + 1)
    $destination = Join-Path $projectDir $relativePath
    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    } else {
        $destDir = Split-Path -Parent $destination
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item -Path $_.FullName -Destination $destination -Force
    }
}

# Append the variant's CLAUDE.md.extension to the base CLAUDE.md
$claudeMdPath = Join-Path $projectDir "CLAUDE.md"
$extensionPath = Join-Path $variantDir "CLAUDE.md.extension"
if (Test-Path $extensionPath) {
    $base = Get-Content -Path $claudeMdPath -Raw
    $ext = Get-Content -Path $extensionPath -Raw
    # Strip the "# variant extensions" first line from the extension since
    # it's just for human readers of the template, not for the new project.
    $extLines = $ext -split "`n", 2
    $extBody = if ($extLines.Count -gt 1) { $extLines[1] } else { $ext }
    Set-Content -Path $claudeMdPath -Value ($base.TrimEnd() + "`n`n" + $extBody.TrimStart()) -Encoding UTF8
}

# Find/replace placeholders
function Replace-Placeholders {
    param([string]$Path)
    $content = Get-Content -Path $Path -Raw
    $content = $content -replace [regex]::Escape("{{PROJECT_NAME}}"), $Name
    $content = $content -replace [regex]::Escape("{{FRONTEND}}"), $Frontend
    $content = $content -replace [regex]::Escape("{{BACKEND}}"), $Backend
    $content = $content -replace [regex]::Escape("{{DB}}"), $DB
    $content = $content -replace [regex]::Escape("{{AUTH}}"), $Auth
    $content = $content -replace [regex]::Escape("{{DEPLOY}}"), $Deploy
    $content = $content -replace [regex]::Escape("{{ENVIRONMENT_NOTES}}"), $EnvironmentNotes
    Set-Content -Path $Path -Value $content -Encoding UTF8
}

Get-ChildItem -Path $projectDir -Recurse -File -Force | Where-Object {
    $_.Extension -in @(".md", ".json", ".tsx", ".ts", ".py", ".css", ".yml", ".yaml")
} | ForEach-Object {
    Replace-Placeholders -Path $_.FullName
}

# Initialize git
if (-not $NoGit) {
    Push-Location $projectDir
    try {
        git init --initial-branch=main | Out-Null
        git add .
        git commit -m "Initial scaffold from claude-project-starter ($Type)" | Out-Null
        Write-Host "Git initialized with first commit." -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

Write-Host ""
Write-Host "Done. Next steps:" -ForegroundColor Green
Write-Host "  cd $projectDir"
Write-Host "  # Open CLAUDE.md and fill in any TBD fields"
Write-Host "  # Add a remote and push:"
Write-Host "  #   gh repo create $Name --private --source=. --push"
