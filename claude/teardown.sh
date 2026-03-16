#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down claude..."

# Nothing to tear down — config, skills and agents are managed by stau

log "claude teardown completed!"
