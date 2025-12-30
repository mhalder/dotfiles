#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Setting up sesh..."

if ! command -v go &>/dev/null; then
  log "Error: Go is not installed. Please install Go first."
  exit 1
fi

log "Go version: $(go version)"

if command -v sesh &>/dev/null; then
  log "sesh is already installed: $(sesh --version 2>/dev/null || echo 'version unknown')"
else
  log "Installing sesh via go install..."
  if go install github.com/joshmedeski/sesh@latest; then
    log "sesh installed successfully"
  else
    log "Error: Failed to install sesh"
    exit 1
  fi
fi

log "Sesh setup completed successfully!"
