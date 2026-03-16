#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v eza &>/dev/null; then
  log "Error: eza is not installed"
  exit 1
fi

log "eza is installed, no additional setup needed."
