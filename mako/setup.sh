#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v mako &>/dev/null; then
  log "Error: mako is not installed"
  exit 1
fi

log "mako is installed, no additional setup needed."
