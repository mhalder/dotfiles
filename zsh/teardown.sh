#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Tearing down zsh plugins..."

if [ -d ~/.oh-my-zsh ]; then
  log "Removing ~/.oh-my-zsh..."
  rm -rf ~/.oh-my-zsh
  log "~/.oh-my-zsh removed"
else
  log "~/.oh-my-zsh does not exist, skipping"
fi

if [ -d ~/.config/zsh-custom/plugins ]; then
  log "Removing ~/.config/zsh-custom/plugins..."
  rm -rf ~/.config/zsh-custom/plugins
  log "~/.config/zsh-custom/plugins removed"
else
  log "~/.config/zsh-custom/plugins does not exist, skipping"
fi

log "Zsh teardown completed successfully!"
