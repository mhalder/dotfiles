#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Installing yazi dependencies..."

sudo apt update
sudo apt install -y trash-cli file ffmpegthumbnailer poppler-utils imagemagick \
  fd-find ripgrep jq unzip p7zip-full

# fd-find installs as fdfind on Debian/Ubuntu
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  log "Creating fd symlink..."
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

log "Yazi dependencies installed successfully!"
