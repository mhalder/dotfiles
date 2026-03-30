#!/usr/bin/env bash
set -euo pipefail

echo "==> Unmasking GCR ssh-agent..."
systemctl --user unmask gcr-ssh-agent.socket gcr-ssh-agent.service
systemctl --user enable gcr-ssh-agent.socket

echo "==> GCR ssh-agent restored (will activate on next login)"
