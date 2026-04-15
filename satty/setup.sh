#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v satty &>/dev/null; then
  log "Error: satty is not installed"
  exit 1
fi

log "satty is installed, no additional setup needed."
