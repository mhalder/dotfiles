#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Tearing down tmux plugins..."

if [ -d ~/.config/tmux/plugins ]; then
  log "Removing ~/.config/tmux/plugins..."
  rm -rf ~/.config/tmux/plugins
  log "~/.config/tmux/plugins removed"
else
  log "~/.config/tmux/plugins does not exist, skipping"
fi

log "Tmux teardown completed successfully!"
