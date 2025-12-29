#!/usr/bin/env bash
# Setup CLI environment (works in VM or LXC)
set -e

echo "[INFO] Starting setup..."

# Passwordless sudo
if ! sudo -n true 2>/dev/null; then
  echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER >/dev/null
  sudo chmod 0440 /etc/sudoers.d/$USER
fi

# Base packages
sudo apt update
sudo apt install -y \
  build-essential curl fd-find fish git golang-go libssl-dev locales \
  pkg-config python3 python3-pip ripgrep tmux unzip wget xclip

sudo locale-gen en_US.UTF-8

# Clone dotfiles
[[ ! -d "$HOME/dotfiles" ]] && git clone https://github.com/mhalder/dotfiles.git "$HOME/dotfiles"

# Rust
if ! command -v cargo &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"

# Cargo tools
command -v cargo-binstall &>/dev/null || cargo install cargo-binstall
for tool in stau eza zoxide tmux-sessionizer; do
  command -v $tool &>/dev/null || cargo binstall -y $tool
done

mkdir -p "$HOME/projects/active" "$HOME/.local/bin"

# Stau packages
echo "[INFO] Installing dotfiles..."
for pkg in fish ghostty git i3 tmux yazi btop dunst eza fzf gh jj k9s lazy oktofetch; do
  [[ -d "$HOME/dotfiles/$pkg" ]] && stau install "$pkg" --force
done

# Setup scripts
[[ -f "$HOME/dotfiles/fzf/setup.sh" ]] && "$HOME/dotfiles/fzf/setup.sh"
[[ -f "$HOME/dotfiles/tmux/setup.sh" ]] && "$HOME/dotfiles/tmux/setup.sh"

# NVM + Node
if [[ ! -d "$HOME/.config/nvm" ]]; then
  export NVM_DIR="$HOME/.config/nvm"
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  source "$NVM_DIR/nvm.sh"
  nvm install --lts
  npm install -g @anthropic-ai/claude-code
fi

# Neovim
command -v nvim &>/dev/null || {
  curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
  tar xzf /tmp/nvim.tar.gz -C /tmp
  cp -r /tmp/nvim-linux-x86_64/* "$HOME/.local/"
  rm -rf /tmp/nvim-linux-x86_64 /tmp/nvim.tar.gz
}

# Neovim config
[[ ! -d "$HOME/.config/nvim" ]] && git clone https://github.com/mhalder/nvim.git "$HOME/.config/nvim"

# kubectl
command -v kubectl &>/dev/null || {
  curl -Lo "$HOME/.local/bin/kubectl" "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x "$HOME/.local/bin/kubectl"
}

echo "[OK] Done! Log out and back in for fish shell."
