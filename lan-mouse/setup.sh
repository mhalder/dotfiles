#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v lan-mouse &>/dev/null; then
  log "Error: lan-mouse is not installed"
  exit 1
fi

log "lan-mouse is installed, no additional setup needed."
