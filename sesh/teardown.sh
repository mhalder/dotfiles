#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Tearing down sesh..."

SESH_BIN="${GOPATH:-$HOME/go}/bin/sesh"

if [ -f "$SESH_BIN" ]; then
  log "Removing sesh binary..."
  rm -f "$SESH_BIN"
  log "sesh binary removed"
else
  log "sesh binary not found at $SESH_BIN, skipping"
fi

log "sesh teardown completed!"
