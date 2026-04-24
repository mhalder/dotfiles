#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v wofi &>/dev/null; then
  log "Error: wofi is not installed"
  exit 1
fi

log "wofi is installed, no additional setup needed."
