#!/bin/bash
set -euo pipefail

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

log "Installing Yazi dependencies for Wayland/Sway..."

sudo apt-get update -y
sudo apt-get install -y \
  trash-cli file ffmpegthumbnailer poppler-utils imagemagick \
  fd-find ripgrep jq unzip p7zip-full 7zip-standalone chafa \
  wl-clipboard xdg-utils mpv

# fd-find installs as fdfind on Debian/Ubuntu
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  log "Creating fd symlink..."
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# Ubuntu ships ImageMagick 6 `convert` in some releases, without `magick`
if ! command -v magick &>/dev/null && command -v convert &>/dev/null; then
  log "Creating magick compatibility wrapper..."
  printf '%s\n' '#!/bin/sh' 'exec convert "$@"' | sudo tee /usr/local/bin/magick >/dev/null
  sudo chmod +x /usr/local/bin/magick
fi

# Install rust-based tools used by Yazi via mise
if command -v mise &>/dev/null; then
  log "Installing rust-based tools via mise (ouch, zoxide)..."
  if ! mise install --yes cargo:ouch@latest zoxide@latest; then
    log "Warning: mise failed to install one or more rust tools"
  fi
  mise reshim || true
else
  log "Warning: mise not found. Install mise to manage rust tools (ouch, zoxide)."
fi

# Install yazi plugins and flavor
if command -v ya &>/dev/null; then
  log "Installing yazi plugins..."
  ya pkg add yazi-rs/plugins:zoxide || log "zoxide plugin may already be installed"
  ya pkg add ndtoan96/ouch || log "ouch plugin may already be installed"

  log "Installing yazi flavor..."
  ya pkg add BennyOe/tokyo-night || log "tokyo-night flavor may already be installed"
else
  log "Warning: 'ya' not found. Install yazi first, then run:"
  log "  ya pkg add yazi-rs/plugins:zoxide"
  log "  ya pkg add ndtoan96/ouch"
  log "  ya pkg add BennyOe/tokyo-night"
fi

log "Yazi setup complete."
