#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down opencode..."

# Nothing to tear down — config is managed by stau

log "opencode teardown completed!"
