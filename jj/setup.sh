#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v jj &>/dev/null; then
  log "Error: jj is not installed"
  exit 1
fi

# Generate fish completions if available
FISH_COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions"
if command -v fish &>/dev/null; then
  log "Generating fish completions..."
  mkdir -p "$FISH_COMPLETIONS_DIR"
  if jj util completion fish >"$FISH_COMPLETIONS_DIR/jj.fish" 2>/dev/null; then
    log "Fish completions installed"
  else
    log "Note: jj completion generation failed"
  fi
fi

log "jj setup completed!"
