#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down lazygit..."

LAZYGIT_LOG="$HOME/.config/lazygit/state.yml"

if [ -f "$LAZYGIT_LOG" ]; then
  log "Removing lazygit state..."
  rm -f "$LAZYGIT_LOG"
fi

log "lazygit teardown completed!"
