#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "Installing yazi dependencies..."

sudo apt-get install -y trash-cli file ffmpegthumbnailer poppler-utils imagemagick \
  fd-find ripgrep jq unzip p7zip-full chafa

# Install ouch for archive previews (requires cargo)
if command -v cargo &>/dev/null; then
  if ! command -v ouch &>/dev/null; then
    log "Installing ouch for archive previews..."
    cargo install ouch
  else
    log "ouch already installed"
  fi
else
  log "Warning: cargo not found. Install Rust to get ouch for archive previews."
fi

# fd-find installs as fdfind on Debian/Ubuntu
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  log "Creating fd symlink..."
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# Install yazi plugins and flavors
if command -v ya &>/dev/null; then
  log "Installing yazi plugins..."
  ya pkg add yazi-rs/plugins:zoxide || log "Note: zoxide plugin may already be installed"
  ya pkg add ndtoan96/ouch || log "Note: ouch plugin may already be installed"
  log "Installing yazi flavors..."
  ya pkg add BennyOe/tokyo-night || log "Note: tokyo-night flavor may already be installed"
  log "Yazi plugins and flavors setup complete!"
else
  log "Warning: 'ya' not found. Install yazi first, then run:"
  log "  ya pkg add yazi-rs/plugins:zoxide"
  log "  ya pkg add ndtoan96/ouch"
  log "  ya pkg add BennyOe/tokyo-night"
fi

log "Yazi dependencies installed successfully!"
