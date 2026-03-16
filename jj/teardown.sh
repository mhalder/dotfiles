#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down jj..."

FISH_COMPLETIONS="$HOME/.config/fish/completions/jj.fish"

if [ -f "$FISH_COMPLETIONS" ]; then
  log "Removing fish completions..."
  rm -f "$FISH_COMPLETIONS"
  log "Fish completions removed"
fi

log "jj teardown completed!"
