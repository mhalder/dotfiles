#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v podman &>/dev/null; then
  log "Error: podman is not installed"
  exit 1
fi

log "podman is installed, no additional setup needed."
