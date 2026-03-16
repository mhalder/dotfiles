#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down i3..."

# Nothing to tear down — config is managed by stau
# System packages (brightnessctl, i3lock-fancy) are preserved

log "i3 teardown completed!"
log "Note: System packages were preserved."
