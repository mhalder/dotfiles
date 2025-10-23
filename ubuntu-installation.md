# Dotfiles Installation Guide

This guide will walk you through setting up a complete development environment using this dotfiles repository on a fresh Linux installation.

## Prerequisites

- A fresh Linux installation (tested on Ubuntu/Debian-based systems)
- SSH keys configured (optional, but recommended for GitHub access)
- Sudo privileges

## Quick Start

```bash
# Clone the repository
git clone <your-dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the main setup script
./setup.sh
```

## Manual Installation

If you prefer step-by-step installation or need to customize the setup:

### 1. Initial System Setup

#### Configure Sudo (Optional)

**Note:** The setup.sh script will prompt you to enable this.

```bash
# For passwordless sudo
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER
sudo chmod 0440 /etc/sudoers.d/$USER
```

#### Install Base Dependencies

```bash
sudo apt update
sudo apt install -y git curl build-essential pkg-config libssl-dev tmux xclip
```

#### Install Window Manager (i3) and utilities

```bash
sudo apt install -y i3 i3status i3lock dunst pavucontrol arandr feh picom
```

#### Install Terminal Emulator (Ghostty)

```bash
sudo snap install ghostty --classic
```

### 2. Install Rust and Cargo

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
```

Add Rust components:

```bash
rustup component add rust-analyzer clippy rustfmt
```

### 3. Install Dotfiles Management Tools

```bash
# Dotfiles manager
cargo install stau

# Binary installer/updater
cargo install oktofetch

# Shell prompt
cargo install starship
```

### 4. Install Dotfiles Packages

Navigate to your dotfiles directory and install packages:

```bash
cd ~/dotfiles

# Install individual packages
stau install <package-name>

# Or install all packages
for pkg in atuin bash btop dunst fzf gh git i3 jj k9s lazy oktofetch starship terminal tmux yazi zsh; do
  stau install $pkg --force
done
```

### 5. Run Package Setup Scripts

Some packages include setup scripts for additional configuration:

```bash
# Example: fzf setup
cd ~/dotfiles/fzf && ./setup.sh

# Example: tmux setup (installs TPM)
cd ~/dotfiles/tmux && ./setup.sh

# Example: zsh setup (installs oh-my-zsh)
cd ~/dotfiles/zsh && ./setup.sh
```

### 6. Install Binary Tools

Use oktofetch to install CLI development tools:

```bash
oktofetch update
```

This installs tools to `~/.local/bin/` including:

- btop, eza, delta, yazi, zoxide (system utilities)
- jj, lazygit, gh (version control)
- k9s, kubectl tools, kind (Kubernetes)
- terraform/tofu, terragrunt (infrastructure)
- And more...

### 7. Shell Configuration

#### Install Zsh

```bash
sudo apt install -y zsh
```

#### Set Zsh as Default Shell

```bash
sudo chsh -s $(which zsh) $USER
```

**Note:** Log out and back in for shell change to take effect.

### 8. Optional Components

#### Node.js Environment

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/latest/install.sh | bash

# Install Node.js
nvm install node
nvm install --lts
```

#### Neovim (from source)

```bash
sudo apt install -y cmake gettext ninja-build
git clone https://github.com/neovim/neovim.git ~/tools/neovim
cd ~/tools/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

#### Neovim Dependencies

```bash
# System packages
sudo apt install -y fd-find ripgrep python3-pynvim imagemagick lldb

# Cargo packages
cargo install tree-sitter-cli

# Node.js provider
npm install -g neovim

# Python virtualenv for neovim
python3 -m venv ~/venv
~/venv/bin/pip install pynvim
```

#### Development Tools

```bash
# Programming languages
sudo apt install -y golang-go python3-pip python3-venv python3-dev

# Lua tools (for Neovim)
sudo apt install -y luarocks

# Additional utilities
sudo apt install -y flameshot ack-grep
```

#### Rust Development

```bash
# cargo-binstall for faster binary installations
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

# Tmux session manager
cargo install tmux-sessionizer
mkdir -p ~/projects/active

# lazyjj - TUI for jujutsu
cargo install lazyjj
```

#### Python Tools

```bash
# uv - Fast Python package manager
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Desktop Environment Enhancements

```bash
# Clipboard manager
sudo apt install -y parcellite
```

#### Fonts

```bash
# Cascadia Code with Nerd Font support
FONT_VERSION="2407.24"
wget https://github.com/microsoft/cascadia-code/releases/download/v${FONT_VERSION}/CascadiaCode-${FONT_VERSION}.zip
unzip CascadiaCode-${FONT_VERSION}.zip -d cascadia
mkdir -p ~/.local/share/fonts/cascadia-code
cp cascadia/ttf/*.ttf ~/.local/share/fonts/cascadia-code/
fc-cache -f -v
rm -rf cascadia CascadiaCode-${FONT_VERSION}.zip
```

#### GitHub CLI

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y
```

#### Docker Engine

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

**Note:** Log out and back in for docker group membership to take effect.

#### Kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

#### Kubernetes Helpers

```bash
# kubectx and kubens - Kubernetes context and namespace switchers
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```

#### DevPod CLI

```bash
curl -L -o ~/.local/bin/devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-$(uname -m)"
chmod +x ~/.local/bin/devpod
```

#### Web Browser

```bash
# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
```

## Post-Installation

### Verify Installation

```bash
# Check shell
echo $SHELL

# Check dotfiles
stau list

# Check binary tools
oktofetch list

# Check Rust
rustc --version
cargo --version

# Check Node.js (if installed)
node --version
npm --version
```

### Configuration

1. **SSH Keys**: Copy your SSH keys to `~/.ssh/`
2. **Environment Variables**: Add custom environment variables to `~/.env` or appropriate config files
3. **Secrets**: Store sensitive data in `Secrets/` directory (gitignored)
4. **Shell History**: Import your shell history to `~/.zsh_history`

### Customization

Each package directory contains:

- Configuration files that symlink to `$HOME`
- Optional `setup.sh` for post-installation tasks
- Optional `teardown.sh` for cleanup on uninstall

To customize:

```bash
# Edit package configs
cd ~/dotfiles/<package>
vim .config/<tool>/config

# Re-install package
stau install <package> --force
```

## Troubleshooting

### Starship Interactive Prompt

If `stau install starship` fails due to interactive prompts:

```bash
cargo install starship
```

### Tmux Plugins Not Loading

```bash
# Install TPM if not already installed
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Inside tmux, press: prefix + I (capital i)
```

### Command Not Found After Installation

Ensure these directories are in your `$PATH`:

- `~/.cargo/bin`
- `~/.local/bin`
- `/snap/bin` (if using snap)

Add to your shell config if missing:

```bash
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
```

## Uninstalling Packages

```bash
# Uninstall a specific package
cd ~/dotfiles/<package>
./teardown.sh  # If teardown script exists
stau uninstall <package>
```

## Additional Resources

- **stau documentation**: Dotfiles manager for symlinking configs
- **oktofetch documentation**: Binary installer/updater for development tools
- **Package-specific READMEs**: Check individual package directories for detailed configuration options

## Notes

- **Passkeys**: Cannot be restored from backups due to WebAuthn security design. Re-register passkeys after restoring password manager backups.
- **Group Membership**: After adding user to groups (e.g., docker), log out and back in for changes to take effect.
- **AppImage Support**: Install `libfuse2` if planning to use AppImage applications.
