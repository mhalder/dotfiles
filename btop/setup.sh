#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v btop &>/dev/null; then
  log "Error: btop is not installed"
  exit 1
fi

log "btop is installed, no additional setup needed."
