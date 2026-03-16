#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down k9s..."

K9S_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/k9s"
K9S_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/k9s"

for dir in "$K9S_CACHE" "$K9S_DATA"; do
  if [ -d "$dir" ]; then
    log "Removing $dir..."
    rm -rf "$dir"
  fi
done

log "k9s teardown completed!"
