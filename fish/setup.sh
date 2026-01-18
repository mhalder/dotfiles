#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

FISHER_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fish/vendor_functions.d/fisher.fish"

# Install fzf binary (required by fzf.fish plugin)
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

# Install fisher and plugins
log "Setting up fisher..."
if [ -f "$FISHER_PATH" ]; then
  log "Fisher already installed, syncing plugins from fish_plugins..."
  fish -c "fisher update" || log "Warning: Failed to update"
else
  log "Installing fisher and plugins from fish_plugins..."
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update' || exit 1
fi

log "Done."
