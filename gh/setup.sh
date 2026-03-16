#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v gh &>/dev/null; then
  log "Error: gh is not installed"
  exit 1
fi

log "Setting up gh..."

# Check auth status
if gh auth status &>/dev/null; then
  log "GitHub CLI is authenticated"
else
  log "Warning: GitHub CLI is not authenticated"
  log "  Run: gh auth login"
fi

log "gh setup completed!"
