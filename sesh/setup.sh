#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Setting up sesh..."

if ! command -v sesh &>/dev/null; then
  log "Error: sesh is not installed"
  log "Hint: install via mise (go:github.com/joshmedeski/sesh/v2)"
  exit 1
fi

log "sesh is installed: $(sesh --version 2>/dev/null || echo 'version unknown')"
log "sesh setup completed!"
