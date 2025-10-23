#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    log_error "This script is designed for Linux systems only."
    exit 1
fi

# Check if we have sudo privileges
if ! sudo -v; then
    log_error "This script requires sudo privileges."
    exit 1
fi

log_info "Starting dotfiles installation..."

# 0. Configure Passwordless Sudo (Optional)
read -p "Do you want to enable passwordless sudo? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Configuring passwordless sudo..."
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER > /dev/null
    sudo chmod 0440 /etc/sudoers.d/$USER
    log_success "Passwordless sudo configured"
else
    log_info "Skipping passwordless sudo configuration"
fi

# 1. Install Base Dependencies
log_info "Installing base dependencies..."
sudo apt update
sudo apt install -y git curl build-essential pkg-config libssl-dev tmux xclip
log_success "Base dependencies installed"

# 2. Install Window Manager (i3) and utilities
log_info "Installing i3 window manager and utilities..."
sudo apt install -y i3 i3status i3lock dunst pavucontrol arandr feh picom
log_success "i3 and utilities installed"

# 3. Install Terminal Emulator (Ghostty)
log_info "Installing Ghostty terminal emulator..."
if command -v snap &>/dev/null; then
    sudo snap install ghostty --classic
    log_success "Ghostty installed"
else
    log_warn "snap not available, skipping Ghostty installation"
fi

# 4. Install Rust and Cargo
if ! command -v cargo &>/dev/null; then
    log_info "Installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    log_success "Rust and Cargo installed"
else
    log_info "Rust and Cargo already installed"
    source "$HOME/.cargo/env"
fi

# Add Rust components
log_info "Adding Rust components..."
rustup component add rust-analyzer clippy rustfmt
log_success "Rust components added"

# 5. Install Dotfiles Management Tools
log_info "Installing dotfiles management tools..."

if ! command -v stau &>/dev/null; then
    log_info "Installing stau..."
    cargo install stau
    log_success "stau installed"
else
    log_info "stau already installed"
fi

if ! command -v oktofetch &>/dev/null; then
    log_info "Installing oktofetch..."
    cargo install oktofetch
    log_success "oktofetch installed"
else
    log_info "oktofetch already installed"
fi

if ! command -v starship &>/dev/null; then
    log_info "Installing starship..."
    cargo install starship
    log_success "starship installed"
else
    log_info "starship already installed"
fi

# 6. Install Dotfiles Packages
log_info "Installing dotfiles packages..."
PACKAGES=(atuin bash btop dunst fzf gh git i3 jj k9s lazy oktofetch starship terminal tmux yazi zsh)

for pkg in "${PACKAGES[@]}"; do
    log_info "Installing package: $pkg"
    if stau install "$pkg" --force; then
        log_success "Package $pkg installed"
    else
        log_warn "Package $pkg installation failed or skipped"
    fi
done

# 7. Run Package Setup Scripts
log_info "Running package setup scripts..."

# FZF setup
if [[ -f "$HOME/dotfiles/fzf/setup.sh" ]]; then
    log_info "Running fzf setup..."
    (cd "$HOME/dotfiles/fzf" && ./setup.sh)
    log_success "fzf setup complete"
fi

# Tmux setup (installs TPM)
if [[ -f "$HOME/dotfiles/tmux/setup.sh" ]]; then
    log_info "Running tmux setup..."
    (cd "$HOME/dotfiles/tmux" && ./setup.sh)
    log_success "tmux setup complete"
fi

# Zsh setup (installs oh-my-zsh)
if [[ -f "$HOME/dotfiles/zsh/setup.sh" ]]; then
    log_info "Running zsh setup..."
    (cd "$HOME/dotfiles/zsh" && ./setup.sh)
    log_success "zsh setup complete"
fi

# 8. Install Binary Tools
log_info "Installing binary tools via oktofetch..."
if oktofetch update; then
    log_success "Binary tools installed to ~/.local/bin/"
else
    log_warn "oktofetch update failed or partially completed"
fi

# 9. Shell Configuration
log_info "Setting up shell configuration..."

# Install Zsh if not already installed
if ! command -v zsh &>/dev/null; then
    log_info "Installing zsh..."
    sudo apt install -y zsh
    log_success "zsh installed"
else
    log_info "zsh already installed"
fi

# Ask user if they want to set zsh as default shell
read -p "Do you want to set zsh as your default shell? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Setting zsh as default shell..."
    sudo chsh -s "$(which zsh)" "$USER"
    log_success "zsh set as default shell"
    log_warn "Please log out and back in for shell change to take effect"
else
    log_info "Skipping zsh as default shell"
fi

# 10. Install Cascadia Code Fonts (Optional)
read -p "Do you want to install Cascadia Code fonts? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -d "$HOME/.local/share/fonts/cascadia-code" ]]; then
        log_info "Installing Cascadia Code fonts..."
        FONT_VERSION="2407.24"
        CASCADIA_ZIP="/tmp/CascadiaCode-${FONT_VERSION}.zip"
        wget -O "$CASCADIA_ZIP" "https://github.com/microsoft/cascadia-code/releases/download/v${FONT_VERSION}/CascadiaCode-${FONT_VERSION}.zip"
        unzip "$CASCADIA_ZIP" -d /tmp/cascadia
        mkdir -p "$HOME/.local/share/fonts/cascadia-code"
        cp /tmp/cascadia/ttf/*.ttf "$HOME/.local/share/fonts/cascadia-code/"
        fc-cache -f -v
        rm -rf /tmp/cascadia "$CASCADIA_ZIP"
        log_success "Cascadia Code fonts installed"
    else
        log_info "Cascadia Code fonts already installed"
    fi
else
    log_info "Skipping Cascadia Code fonts installation"
fi

# 11. Install Google Chrome (Optional)
read -p "Do you want to install Google Chrome? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v google-chrome &>/dev/null; then
        log_info "Installing Google Chrome..."
        CHROME_DEB="/tmp/google-chrome-stable_current_amd64.deb"
        wget -O "$CHROME_DEB" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt install -y "$CHROME_DEB"
        rm "$CHROME_DEB"
        log_success "Google Chrome installed"
    else
        log_info "Google Chrome already installed"
    fi
else
    log_info "Skipping Google Chrome installation"
fi

# 12. Install uv (Fast Python package manager) (Optional)
read -p "Do you want to install uv (Fast Python package manager)? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v uv &>/dev/null; then
        log_info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        log_success "uv installed"
    else
        log_info "uv already installed"
    fi
else
    log_info "Skipping uv installation"
fi

# Verify installation
log_info "Verifying installation..."
echo ""
log_info "Rust version: $(rustc --version)"
log_info "Cargo version: $(cargo --version)"
log_info "Stau packages:"
stau list || log_warn "Could not list stau packages"
echo ""
log_info "Oktofetch binaries:"
oktofetch list || log_warn "Could not list oktofetch binaries"
echo ""

log_success "Dotfiles installation complete!"
echo ""
log_info "Next steps:"
echo "  1. Log out and back in if you changed your default shell"
echo "  2. Configure SSH keys in ~/.ssh/"
echo "  3. Add custom environment variables to ~/.env"
echo "  4. Review ubuntu-installation.md for optional components"
echo ""
log_info "Optional components to consider:"
echo "  - Node.js (nvm)"
echo "  - Neovim (from source)"
echo "  - Docker Engine"
echo "  - kubectl"
echo ""
