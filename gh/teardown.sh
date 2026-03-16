#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down gh..."

GH_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/gh"

if [ -d "$GH_CACHE" ]; then
  log "Removing gh cache..."
  rm -rf "$GH_CACHE"
  log "gh cache removed"
else
  log "gh cache not found, skipping"
fi

log "gh teardown completed!"
log "Note: Authentication credentials were preserved."
