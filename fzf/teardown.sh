#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down fzf..."

if [ -d ~/.fzf ]; then
  rm -rf ~/.fzf
  log "Removed ~/.fzf"
else
  log "~/.fzf does not exist, skipping"
fi

log "Done."
