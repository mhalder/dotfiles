#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down git..."

# Note: git credentials are NOT removed

log "git teardown completed!"
log "Note: Git credentials were preserved."
