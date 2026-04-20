#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down sesh..."
log "No binary cleanup needed (sesh managed by mise)."
log "sesh teardown completed!"
