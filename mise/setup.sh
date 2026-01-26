#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

MISE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
FISH_COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions"

# Check if mise is installed
if ! command -v mise &>/dev/null; then
  log "Error: mise is not installed. Install it first:"
  log "  curl https://mise.run | sh"
  exit 1
fi

log "Setting up mise..."

# Trust the mise configuration directory
log "Trusting mise config directory..."
mise trust "$MISE_CONFIG_DIR" 2>/dev/null || true

# Install all tools defined in config.toml
log "Installing mise tools (this may take a while)..."
if mise install --yes; then
  log "All mise tools installed successfully"
else
  log "Warning: Some tools may have failed to install"
fi

# Generate fish completions if fish is available
if command -v fish &>/dev/null; then
  log "Generating fish completions..."
  mkdir -p "$FISH_COMPLETIONS_DIR"
  mise completion fish >"$FISH_COMPLETIONS_DIR/mise.fish"
  log "Fish completions installed to $FISH_COMPLETIONS_DIR/mise.fish"
fi

# Reshim to ensure all shims are up to date
log "Updating shims..."
mise reshim

# Show installed tools summary
log "Installed tools:"
mise list --current 2>/dev/null | head -20 || true

log "Mise setup completed successfully!"
