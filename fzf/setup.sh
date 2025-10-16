#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Setting up fzf..."
if [ -d ~/.fzf ]; then
  log "fzf already exists, updating..."
  if git -C ~/.fzf pull --quiet; then
    log "fzf updated successfully"
  else
    log "Warning: Failed to update fzf (continuing anyway)"
  fi
else
  log "Cloning fzf..."
  if git clone --quiet https://github.com/junegunn/fzf.git ~/.fzf; then
    log "fzf cloned successfully"
  else
    log "Error: Failed to clone fzf"
    exit 1
  fi
fi

log "Setting up fzf-git..."
if [ -d ~/.fzf-git ]; then
  log "fzf-git already exists, updating..."
  if git -C ~/.fzf-git pull --quiet; then
    log "fzf-git updated successfully"
  else
    log "Warning: Failed to update fzf-git (continuing anyway)"
  fi
else
  log "Cloning fzf-git..."
  if git clone --quiet https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git; then
    log "fzf-git cloned successfully"
  else
    log "Error: Failed to clone fzf-git"
    exit 1
  fi
fi

log "Running fzf install..."
if ~/.fzf/install --no-bash --no-zsh --no-update-rc >/dev/null 2>&1; then
  log "fzf install completed successfully"
else
  log "Error: fzf install failed"
  exit 1
fi

log "fzf setup completed successfully!"
