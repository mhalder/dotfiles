#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

FISH_COMPLETIONS="$HOME/.config/fish/completions/fnox.fish"
FNOX_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/fnox"

log "Tearing down fnox..."

# Remove fish completions
if [ -f "$FISH_COMPLETIONS" ]; then
  log "Removing fish completions..."
  rm -f "$FISH_COMPLETIONS"
  log "Fish completions removed"
else
  log "Fish completions not found, skipping"
fi

# Remove fnox cache if it exists
if [ -d "$FNOX_CACHE_DIR" ]; then
  log "Removing fnox cache directory..."
  rm -rf "$FNOX_CACHE_DIR"
  log "Fnox cache removed"
else
  log "Fnox cache directory not found, skipping"
fi

# Note: We intentionally do NOT remove ~/.vault-token
# as it contains authentication credentials that may be used
# by other tools (vault CLI, terraform, etc.)

log "Fnox teardown completed!"
log "Note: Vault token at ~/.vault-token was preserved (used by other tools)."
