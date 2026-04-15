#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v waybar &>/dev/null; then
  log "Error: waybar is not installed"
  exit 1
fi

log "waybar is installed, no additional setup needed."
