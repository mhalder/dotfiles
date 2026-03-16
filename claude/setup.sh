#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v claude &>/dev/null; then
  log "Error: claude is not installed"
  exit 1
fi

log "Setting up claude..."

# Hooks require python3
if ! command -v python3 &>/dev/null; then
  log "Warning: python3 not found, hooks may not work"
  log "  Install: sudo apt-get install python3"
fi

log "claude setup completed!"
