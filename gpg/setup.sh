#!/usr/bin/env bash
set -euo pipefail

echo "==> Disabling GCR ssh-agent..."
systemctl --user disable --now gcr-ssh-agent.socket gcr-ssh-agent.service 2>/dev/null || true
systemctl --user mask gcr-ssh-agent.socket gcr-ssh-agent.service

echo "==> Restarting gpg-agent..."
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

echo "==> gpg-agent SSH socket: $(gpgconf --list-dirs agent-ssh-socket)"
echo "==> Add SSH keys with: ssh-add ~/.ssh/id_ed25519"
