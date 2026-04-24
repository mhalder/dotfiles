#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down wofi..."

WOFI_CACHE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}"
WOFI_CACHE_GLOB="$WOFI_CACHE_ROOT/wofi-*"

if compgen -G "$WOFI_CACHE_GLOB" >/dev/null; then
  log "Removing wofi cache files..."
  rm -f $WOFI_CACHE_GLOB
  log "wofi cache removed"
else
  log "No wofi cache files found, skipping"
fi

log "wofi teardown completed!"
