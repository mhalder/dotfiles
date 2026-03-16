#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v lazygit &>/dev/null; then
  log "Error: lazygit is not installed"
  exit 1
fi

log "lazygit is installed, no additional setup needed."
