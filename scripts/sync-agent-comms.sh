#!/usr/bin/env bash
# sync-agent-comms.sh
#
# Keeps the cross-repo agent-communication doc in sync between two
# checkouts. Both agents edit the same logical file in two physical
# locations; this script reconciles them by picking the newer file
# and copying it to the other side.
#
# Configuration:
#   Local file:   resolved relative to this script (docs/assets/<COMMS_FILENAME>)
#   Remote file:  taken from the AGENT_COMMS_REMOTE environment variable
#                 OR from a .sync-config file in the repo root
#                 OR from the --remote argument
#
# Usage:
#   ./scripts/sync-agent-comms.sh                       # interactive confirm
#   ./scripts/sync-agent-comms.sh --yes                 # no prompt
#   ./scripts/sync-agent-comms.sh --dry-run             # show what would happen
#   ./scripts/sync-agent-comms.sh --remote /path/file   # one-off override
#
# Works on Linux, macOS, WSL, Git-Bash on Windows. Falls back to BSD stat/date
# when GNU coreutils aren't available.

set -euo pipefail

COMMS_FILENAME="2026-05-21-project-starter-recommendations.md"

YES=0
DRY_RUN=0
REMOTE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes|-y)     YES=1; shift ;;
    --dry-run)    DRY_RUN=1; shift ;;
    --remote)     REMOTE="$2"; shift 2 ;;
    -h|--help)    grep '^#' "$0" | sed 's/^# \{0,1\}//' | head -22; exit 0 ;;
    *)            echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

# Resolve script-relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCAL="$REPO_ROOT/docs/assets/$COMMS_FILENAME"

# Resolve remote: argument > env var > .sync-config
if [[ -z "$REMOTE" ]]; then REMOTE="${AGENT_COMMS_REMOTE:-}"; fi
if [[ -z "$REMOTE" && -f "$REPO_ROOT/.sync-config" ]]; then
  REMOTE="$(grep '^AGENT_COMMS_REMOTE=' "$REPO_ROOT/.sync-config" | head -1 | cut -d= -f2-)"
fi
if [[ -z "$REMOTE" ]]; then
  echo "ERROR No remote path configured." >&2
  echo "      Provide one of:" >&2
  echo "        --remote <path>" >&2
  echo "        AGENT_COMMS_REMOTE=<path> ./scripts/sync-agent-comms.sh" >&2
  echo "        Create $REPO_ROOT/.sync-config with: AGENT_COMMS_REMOTE=<path>" >&2
  exit 2
fi

# Normalize Windows-style paths (C:\foo\bar) to POSIX (C:/foo/bar) so that
# coreutils like md5sum/stat don't get tripped by backslashes. GNU md5sum
# prefixes the hash with a backslash when the filename contains one,
# breaking simple field extraction. Bash-style replacement keeps it portable.
REMOTE="${REMOTE//\\//}"

# Cross-platform stat (GNU vs BSD) — returns mtime as epoch
mtime() {
  if stat -c %Y "$1" >/dev/null 2>&1; then stat -c %Y "$1"
  else stat -f %m "$1"; fi
}
size() {
  if stat -c %s "$1" >/dev/null 2>&1; then stat -c %s "$1"
  else stat -f %z "$1"; fi
}
md5() { md5sum "$1" | { read -r h _; echo "$h"; }; }

for p in "$LOCAL" "$REMOTE"; do
  if [[ ! -f "$p" ]]; then
    echo "MISS  $p"
    echo "      File doesn't exist. Create it manually if this is the first sync."
    exit 1
  fi
done

local_hash="$(md5 "$LOCAL")"
remote_hash="$(md5 "$REMOTE")"

if [[ "$local_hash" == "$remote_hash" ]]; then
  echo "OK    Already in sync (MD5: $local_hash)"
  exit 0
fi

local_mtime="$(mtime "$LOCAL")"
remote_mtime="$(mtime "$REMOTE")"

if [[ $local_mtime -gt $remote_mtime ]]; then
  src="$LOCAL";  src_label="local";  src_hash="$local_hash"
  dst="$REMOTE"; dst_label="remote"
else
  src="$REMOTE"; src_label="remote"; src_hash="$remote_hash"
  dst="$LOCAL";  dst_label="local"
fi

echo "SYNC  $src_label -> $dst_label"
echo "      Source: $src (mtime $(mtime "$src"), $(size "$src") bytes)"
echo "      Dest:   $dst (mtime $(mtime "$dst"), $(size "$dst") bytes)"

if [[ $DRY_RUN -eq 1 ]]; then
  echo "      [DRY RUN] Would overwrite dest."
  exit 0
fi

if [[ $YES -eq 0 ]]; then
  read -rp "Proceed with sync? [y/N] " confirm
  case "$confirm" in y|Y) ;; *) echo "Aborted."; exit 0 ;; esac
fi

cp -f "$src" "$dst"

new_dst_hash="$(md5 "$dst")"
if [[ "$new_dst_hash" == "$src_hash" ]]; then
  echo "OK    Synced (MD5: $new_dst_hash)"
else
  echo "FAIL  Checksums diverged after copy. Investigate." >&2
  exit 1
fi
