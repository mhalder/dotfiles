#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down dunst..."

# Nothing to tear down — config is managed by stau

log "dunst teardown completed!"
