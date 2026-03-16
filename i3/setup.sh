#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if ! command -v i3 &>/dev/null; then
  log "Error: i3 is not installed"
  exit 1
fi

log "Setting up i3 dependencies..."

log "Installing dependencies..."
sudo apt-get install -y brightnessctl i3lock-fancy picom

log "i3 setup completed!"
