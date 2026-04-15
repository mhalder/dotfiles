#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down lan-mouse..."
log "lan-mouse teardown completed!"
