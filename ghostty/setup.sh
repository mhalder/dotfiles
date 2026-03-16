#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v ghostty &>/dev/null; then
  log "Error: ghostty is not installed"
  exit 1
fi

log "ghostty is installed, no additional setup needed."
