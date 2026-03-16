#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down yazi..."

# Remove yazi plugins and flavors
YAZI_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/yazi"
YAZI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/yazi"

for dir in "$YAZI_STATE" "$YAZI_DATA"; do
  if [ -d "$dir" ]; then
    log "Removing $dir..."
    rm -rf "$dir"
    log "$dir removed"
  else
    log "$dir not found, skipping"
  fi
done

# Remove ouch if installed via cargo
if command -v ouch &>/dev/null; then
  OUCH_BIN="$HOME/.cargo/bin/ouch"
  if [ -f "$OUCH_BIN" ]; then
    log "Removing ouch..."
    rm -f "$OUCH_BIN"
    log "ouch removed"
  fi
fi

log "yazi teardown completed!"
log "Note: System packages (trash-cli, ffmpegthumbnailer, etc.) were preserved."
