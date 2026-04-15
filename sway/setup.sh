#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v sway &>/dev/null; then
  log "Error: sway is not installed"
  exit 1
fi

log "sway is installed, no additional setup needed."
