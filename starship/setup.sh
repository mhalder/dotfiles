#!/bin/bash

# Install starship if not present
if ! command -v starship &> /dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh
else
    echo "Starship is already installed"
fi
