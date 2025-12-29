#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

FISHER_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fish/vendor_functions.d/fisher.fish"

FISH_PLUGINS="${XDG_CONFIG_HOME:-$HOME/.config}/fish/fish_plugins"

log "Setting up fisher..."
if [ -f "$FISHER_PATH" ]; then
  log "Fisher already installed, syncing plugins from fish_plugins..."
  fish -c "fisher update" || log "Warning: Failed to update"
else
  log "Installing fisher and plugins from fish_plugins..."
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update' || exit 1
fi

log "Done."
