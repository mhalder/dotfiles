#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v rg &>/dev/null; then
  log "Error: ripgrep is not installed"
  exit 1
fi

log "ripgrep is installed, no additional setup needed."
