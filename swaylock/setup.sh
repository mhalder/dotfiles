#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v swaylock &>/dev/null; then
  log "Error: swaylock is not installed"
  exit 1
fi

log "swaylock is installed, no additional setup needed."
