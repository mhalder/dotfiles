#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down btop..."

BTOP_LOG="$HOME/.config/btop/btop.log"

if [ -f "$BTOP_LOG" ]; then
  log "Removing btop log..."
  rm -f "$BTOP_LOG"
fi

log "btop teardown completed!"
