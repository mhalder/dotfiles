#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down mako..."
log "mako teardown completed!"
