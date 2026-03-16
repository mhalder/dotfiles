#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v git &>/dev/null; then
  log "Error: git is not installed"
  exit 1
fi

log "git is installed, no additional setup needed."
