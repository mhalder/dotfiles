#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Setting up fzf..."
if [ -d ~/.fzf ]; then
  log "Updating fzf..."
  git -C ~/.fzf pull --quiet || log "Warning: Failed to update"
else
  log "Cloning fzf..."
  git clone --depth 1 --quiet https://github.com/junegunn/fzf.git ~/.fzf || exit 1
fi

log "Installing fzf binary..."
~/.fzf/install --bin >/dev/null 2>&1 || exit 1

log "Done. Use 'fisher install PatrickF1/fzf.fish' for shell integration."
