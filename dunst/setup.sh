#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v dunst &>/dev/null; then
  log "Error: dunst is not installed"
  exit 1
fi

log "dunst is installed, no additional setup needed."
