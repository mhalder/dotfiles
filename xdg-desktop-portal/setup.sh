#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "xdg-desktop-portal config installed."
log "Ensure xdg-desktop-portal, xdg-desktop-portal-gtk, and xdg-desktop-portal-wlr are installed."
