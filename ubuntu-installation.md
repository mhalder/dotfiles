# Dotfiles Installation Guide

This guide will walk you through setting up a complete development environment using this dotfiles repository on a fresh Linux installation.

## Prerequisites

- A fresh Linux installation (tested on Ubuntu/Debian-based systems)
- SSH keys configured (optional, but recommended for GitHub access)
- Sudo privileges

## Quick Start

For most users, the automated setup script handles everything:

```bash
# Clone the repository
git clone https://github.com/mhalder/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the automated setup script
./setup.sh
```

The setup script installs:
- Base system dependencies (build tools, git, curl, etc.)
- Desktop environment (Xorg, LightDM, i3)
- Terminal emulator (Ghostty)
- Rust toolchain and cargo tools
- Dotfile manager (stau) and all configuration packages
- Neovim with configuration
- Node.js (nvm) with Claude Code CLI
- Python tools (uv, virtualenv)
- Kubernetes tools (kubectl, k9s)
- And many more development tools

See the main [README](README.md) for configuration options via environment variables.

## Manual Installation

If you prefer step-by-step installation or need to customize specific components:

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

> **Note**: Most of these components are automatically installed by `setup.sh`. This section is for manual installation or reinstallation.

#### Node.js Environment (Installed by setup.sh)

The setup script installs nvm to `~/.config/nvm` with both LTS and latest Node.js:

```bash
# Manual installation if needed
export NVM_DIR="$HOME/.config/nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js versions
nvm install --lts
nvm install node

# Install Claude Code CLI and other tools
npm install -g @anthropic-ai/claude-code opencode-ai neovim
```

#### Neovim (Installed by setup.sh)

The setup script installs Neovim v0.11.4 as a pre-built binary:

```bash
# Manual installation if needed
mkdir -p "$HOME/.local/bin"
NVIM_VERSION="v0.11.4"
curl -L "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" -o /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C /tmp
cp -r /tmp/nvim-linux-x86_64/* "$HOME/.local/"
rm -rf /tmp/nvim-linux-x86_64 /tmp/nvim.tar.gz
```

Alternatively, build from source for the latest features:

```bash
sudo apt install -y cmake gettext
git clone https://github.com/neovim/neovim.git ~/tools/neovim
cd ~/tools/neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

#### Neovim Configuration (Installed by setup.sh)

The setup script clones the Neovim configuration automatically:

```bash
# Manual installation if needed
git clone https://github.com/mhalder/nvim.git "$HOME/.config/nvim"
```

#### Python virtualenv for Neovim (Installed by setup.sh)

The setup script creates a Python virtualenv with pynvim:

```bash
# Manual installation if needed
uv venv "$HOME/venv"
uv pip install --python "$HOME/venv/bin/python" pynvim
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

#### Rust Development (Installed by setup.sh)

The setup script installs cargo-binstall and tmux-sessionizer:

```bash
# Manual installation if needed
cargo install cargo-binstall
cargo install tmux-sessionizer
mkdir -p ~/projects/active

# Optional: lazyjj - TUI for jujutsu
cargo install lazyjj
```

#### Python Tools (Installed by setup.sh)

The setup script installs uv:

```bash
# Manual installation if needed
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Desktop Environment Enhancements

```bash
# Clipboard manager
sudo apt install -y parcellite
```

#### Fonts (Installed by setup.sh)

The setup script installs Cascadia Code fonts:

```bash
# Manual installation if needed
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

#### Kubectl (Installed by setup.sh)

The setup script installs kubectl to `~/.local/bin/`:

```bash
# Manual installation if needed
mkdir -p "$HOME/.local/bin"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl "$HOME/.local/bin/"
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

#### Web Browser (Installed by setup.sh)

The setup script installs Google Chrome:

```bash
# Manual installation if needed
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
