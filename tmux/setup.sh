#!/bin/bash
mkdir -p ~/.config/tmux/plugins

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo "TPM already exists, updating..."
    git -C "$TPM_DIR" pull
else
    echo "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
