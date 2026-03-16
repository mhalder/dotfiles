#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down fish plugins..."

# Remove fzf
if [ -d "$HOME/.fzf" ]; then
  log "Removing fzf..."
  rm -rf "$HOME/.fzf"
  log "fzf removed"
else
  log "fzf not found, skipping"
fi

# Remove fisher and plugins
FISHER_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/fish"
if [ -f "$FISHER_DATA/vendor_functions.d/fisher.fish" ]; then
  log "Removing fisher and plugins..."
  fish -c "fisher list | fisher remove" 2>/dev/null || true
  rm -f "$FISHER_DATA/vendor_functions.d/fisher.fish"
  log "Fisher and plugins removed"
else
  log "Fisher not found, skipping"
fi

log "fish teardown completed!"
