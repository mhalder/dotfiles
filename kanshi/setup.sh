#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v kanshi &>/dev/null; then
  log "Error: kanshi is not installed"
  exit 1
fi

log "kanshi is installed, no additional setup needed."
