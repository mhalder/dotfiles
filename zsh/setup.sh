#!/bin/bash
set -euo pipefail

# Helper functions
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Setting up zsh plugins directory..."
mkdir -p ~/.config/zsh-custom/plugins

log "Setting up oh-my-zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
  log "Cloning oh-my-zsh..."
  if git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh; then
    log "oh-my-zsh cloned successfully"
  else
    log "Error: Failed to clone oh-my-zsh"
    exit 1
  fi
else
  log "oh-my-zsh already exists, updating..."
  if git -C ~/.oh-my-zsh pull; then
    log "oh-my-zsh updated successfully"
  else
    log "Warning: Failed to update oh-my-zsh (continuing anyway)"
  fi
fi

log "Setting up zsh-autosuggestions..."
if [ ! -d ~/.config/zsh-custom/plugins/zsh-autosuggestions ]; then
  log "Cloning zsh-autosuggestions..."
  if git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-custom/plugins/zsh-autosuggestions; then
    log "zsh-autosuggestions cloned successfully"
  else
    log "Error: Failed to clone zsh-autosuggestions"
    exit 1
  fi
else
  log "zsh-autosuggestions already exists, updating..."
  if git -C ~/.config/zsh-custom/plugins/zsh-autosuggestions pull; then
    log "zsh-autosuggestions updated successfully"
  else
    log "Warning: Failed to update zsh-autosuggestions (continuing anyway)"
  fi
fi

log "Zsh setup completed successfully!"
