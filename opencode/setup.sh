#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v opencode &>/dev/null; then
  log "Error: opencode is not installed"
  exit 1
fi

log "opencode is installed, no additional setup needed."
