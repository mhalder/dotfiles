#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down containers..."

# Note: Container storage is NOT removed to preserve images/volumes

log "containers teardown completed!"
log "Note: Container storage was preserved."
