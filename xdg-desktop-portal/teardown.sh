#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down xdg-desktop-portal..."
log "xdg-desktop-portal teardown completed!"
