#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Setting up tmux plugins directory..."
mkdir -p ~/.config/tmux/plugins

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

log "Setting up TPM (Tmux Plugin Manager)..."
if [ -d "$TPM_DIR" ]; then
  log "TPM already exists, updating..."
  if git -C "$TPM_DIR" pull; then
    log "TPM updated successfully"
  else
    log "Warning: Failed to update TPM (continuing anyway)"
  fi
else
  log "Cloning TPM..."
  if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
    log "TPM cloned successfully"
  else
    log "Error: Failed to clone TPM"
    exit 1
  fi
fi

log "Installing tmux plugins via TPM..."
if [ -f "$TPM_DIR/bin/install_plugins" ]; then
  "$TPM_DIR/bin/install_plugins"
  log "TPM plugins installed successfully"
else
  log "Warning: TPM install_plugins script not found"
fi

log "Tmux setup completed successfully!"
