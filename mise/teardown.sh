#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

MISE_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mise"
MISE_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mise"
FISH_COMPLETIONS="$HOME/.config/fish/completions/mise.fish"

log "Tearing down mise..."

# Remove fish completions
if [ -f "$FISH_COMPLETIONS" ]; then
  log "Removing fish completions..."
  rm -f "$FISH_COMPLETIONS"
  log "Fish completions removed"
else
  log "Fish completions not found, skipping"
fi

# Remove mise cache
if [ -d "$MISE_CACHE_DIR" ]; then
  log "Removing mise cache directory..."
  rm -rf "$MISE_CACHE_DIR"
  log "Mise cache removed"
else
  log "Mise cache directory not found, skipping"
fi

# Optionally remove installed tools (mise data directory)
# This is commented out by default to preserve installed tools
# Uncomment if you want a complete teardown
#
# if [ -d "$MISE_DATA_DIR" ]; then
#   log "Removing mise data directory (installed tools)..."
#   rm -rf "$MISE_DATA_DIR"
#   log "Mise data directory removed"
# else
#   log "Mise data directory not found, skipping"
# fi

log "Mise teardown completed!"
log "Note: Installed tools in $MISE_DATA_DIR were preserved."
log "      To remove them, uncomment the relevant section in this script."
