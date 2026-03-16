#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v k9s &>/dev/null; then
  log "Error: k9s is not installed"
  exit 1
fi

log "k9s is installed, no additional setup needed."
