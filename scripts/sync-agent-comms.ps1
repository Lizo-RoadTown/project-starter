# sync-agent-comms.ps1
#
# Keeps the cross-repo agent-communication doc in sync between two
# checkouts. Both agents edit the same logical file in two physical
# locations; this script reconciles them by picking the newer file
# and copying it to the other side.
#
# Configuration:
#   Local file:   resolved relative to this script (docs/assets/<COMMS_FILENAME>)
#   Remote file:  taken from the AGENT_COMMS_REMOTE environment variable
#                 OR from a .sync-config file in this script's parent dir
#                 OR from the -RemotePath argument
#
# Usage:
#   ./scripts/sync-agent-comms.ps1                       # interactive confirm
#   ./scripts/sync-agent-comms.ps1 -Yes                  # no prompt
#   ./scripts/sync-agent-comms.ps1 -DryRun               # show what would happen
#   ./scripts/sync-agent-comms.ps1 -RemotePath C:\path   # one-off override
#
# Example .sync-config (one path per line, key=value):
#   AGENT_COMMS_REMOTE=C:\Users\Liz\Make_Skills\docs\plans\2026-05-21-project-starter-recommendations.md

[CmdletBinding()]
param(
    [switch]$Yes,
    [switch]$DryRun,
    [string]$RemotePath = ""
)

$ErrorActionPreference = "Stop"

$COMMS_FILENAME = "2026-05-21-project-starter-recommendations.md"
$repoRoot = Split-Path -Parent $PSScriptRoot
$local = Join-Path $repoRoot "docs\assets\$COMMS_FILENAME"

# Resolve remote: argument > env var > .sync-config
$remote = $RemotePath
if (-not $remote) { $remote = $env:AGENT_COMMS_REMOTE }
if (-not $remote) {
    $configPath = Join-Path $repoRoot ".sync-config"
    if (Test-Path $configPath) {
        $line = Get-Content $configPath | Where-Object { $_ -match '^AGENT_COMMS_REMOTE=' } | Select-Object -First 1
        if ($line) { $remote = $line -replace '^AGENT_COMMS_REMOTE=', '' }
    }
}
if (-not $remote) {
    Write-Host "ERROR No remote path configured." -ForegroundColor Red
    Write-Host "      Provide one of:"
    Write-Host "        -RemotePath <path>"
    Write-Host "        `$env:AGENT_COMMS_REMOTE = '<path>'"
    Write-Host "        Create $repoRoot\.sync-config with: AGENT_COMMS_REMOTE=<path>"
    exit 2
}

foreach ($p in @($local, $remote)) {
    if (-not (Test-Path $p)) {
        Write-Host "MISS  $p" -ForegroundColor Red
        Write-Host "      File doesn't exist. Create it manually if this is the first sync."
        exit 1
    }
}

$localHash  = (Get-FileHash $local  -Algorithm MD5).Hash
$remoteHash = (Get-FileHash $remote -Algorithm MD5).Hash

if ($localHash -eq $remoteHash) {
    Write-Host "OK    Already in sync (MD5: $localHash)" -ForegroundColor Green
    exit 0
}

$localInfo  = Get-Item $local
$remoteInfo = Get-Item $remote

if ($localInfo.LastWriteTime -gt $remoteInfo.LastWriteTime) {
    $src = $local;  $srcLabel = "local";  $srcInfo = $localInfo;  $srcHash = $localHash
    $dst = $remote; $dstLabel = "remote"; $dstInfo = $remoteInfo
} else {
    $src = $remote; $srcLabel = "remote"; $srcInfo = $remoteInfo; $srcHash = $remoteHash
    $dst = $local;  $dstLabel = "local";  $dstInfo = $localInfo
}

Write-Host "SYNC  $srcLabel -> $dstLabel" -ForegroundColor Cyan
Write-Host "      Source: $src ($($srcInfo.LastWriteTime), $($srcInfo.Length) bytes)"
Write-Host "      Dest:   $dst ($($dstInfo.LastWriteTime), $($dstInfo.Length) bytes)"

if ($DryRun) {
    Write-Host "      [DRY RUN] Would overwrite dest." -ForegroundColor DarkGray
    exit 0
}

if (-not $Yes) {
    $confirm = Read-Host "Proceed with sync? [y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
    }
}

Copy-Item -Path $src -Destination $dst -Force

$newDstHash = (Get-FileHash $dst -Algorithm MD5).Hash
if ($newDstHash -eq $srcHash) {
    Write-Host "OK    Synced (MD5: $newDstHash)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "FAIL  Checksums diverged after copy. Investigate." -ForegroundColor Red
    exit 1
}
