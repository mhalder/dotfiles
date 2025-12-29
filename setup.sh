#!/usr/bin/env bash
set -e

echo "[INFO] Starting setup..."

# Base packages
sudo apt update
sudo apt install -y \
  build-essential curl fd-find fish git golang-go libssl-dev locales \
  pkg-config python3 python3-pip python-is-python3 ripgrep tmux unzip wget xclip

sudo locale-gen en_US.UTF-8

# Rust
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
rustup default nightly

# Cargo tools
command -v cargo-binstall &>/dev/null || cargo install cargo-binstall
for tool in stau oktofetch; do
  command -v $tool &>/dev/null || cargo binstall -y $tool
done

# nvm + Node
export NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
source "$NVM_DIR/nvm.sh"
nvm install --lts

stau install fish
stau install oktofetch
stau install tmux

stau install btop
stau install dunst
stau install eza
stau install gh
stau install ghostty
stau install git
stau install i3
stau install jj
stau install k9s
stau install lazy
stau install yazi
~/dotfiles/fzf/setup.sh

oktofetch update

# # Neovim
# command -v nvim &>/dev/null || {
#   curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
#   tar xzf /tmp/nvim.tar.gz -C /tmp
#   cp -r /tmp/nvim-linux-x86_64/* "$HOME/.local/"
#   rm -rf /tmp/nvim-linux-x86_64 /tmp/nvim.tar.gz
# }
#
# # Neovim config
# [[ ! -d "$HOME/.config/nvim" ]] && git clone https://github.com/mhalder/nvim.git "$HOME/.config/nvim"
