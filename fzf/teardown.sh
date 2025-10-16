#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Tearing down fzf..."

if [ -d ~/.fzf ]; then
  log "Removing ~/.fzf..."
  rm -rf ~/.fzf
  log "~/.fzf removed"
else
  log "~/.fzf does not exist, skipping"
fi

if [ -d ~/.fzf-git ]; then
  log "Removing ~/.fzf-git..."
  rm -rf ~/.fzf-git
  log "~/.fzf-git removed"
else
  log "~/.fzf-git does not exist, skipping"
fi

log "fzf teardown completed successfully!"
