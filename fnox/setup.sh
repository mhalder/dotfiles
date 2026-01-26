#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

VAULT_TOKEN_FILE="$HOME/.vault-token"
FISH_COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions"

# Check if fnox is installed
if ! command -v fnox &>/dev/null; then
  log "Error: fnox is not installed. Install it via mise:"
  log "  mise install fnox"
  exit 1
fi

log "Setting up fnox..."

# Check for vault token
if [ -f "$VAULT_TOKEN_FILE" ]; then
  log "Vault token found at $VAULT_TOKEN_FILE"
  export VAULT_TOKEN=$(cat "$VAULT_TOKEN_FILE")
else
  log "Warning: No vault token found at $VAULT_TOKEN_FILE"
  log "  To authenticate with Vault, run:"
  log "    vault login -method=<method>"
  log "  Or create the token file manually:"
  log "    echo 'your-token' > $VAULT_TOKEN_FILE"
  log "    chmod 600 $VAULT_TOKEN_FILE"
fi

# Verify vault connectivity if token exists
if [ -n "${VAULT_TOKEN:-}" ]; then
  log "Verifying Vault connectivity..."
  if vault token lookup &>/dev/null; then
    log "Vault connection verified successfully"
  else
    log "Warning: Could not verify Vault connection"
    log "  Check that VAULT_ADDR is set correctly and the token is valid"
  fi
fi

# Generate fish completions if available
if command -v fish &>/dev/null; then
  log "Generating fish completions..."
  mkdir -p "$FISH_COMPLETIONS_DIR"
  if fnox completion fish >"$FISH_COMPLETIONS_DIR/fnox.fish" 2>/dev/null; then
    log "Fish completions installed to $FISH_COMPLETIONS_DIR/fnox.fish"
  else
    log "Note: fnox completion generation not available or failed"
  fi
fi

log "Fnox setup completed!"
log "  Config: ${XDG_CONFIG_HOME:-$HOME/.config}/fnox/config.toml"
log "  Token:  $VAULT_TOKEN_FILE"
