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
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER >/dev/null
    sudo chmod 0440 /etc/sudoers.d/$USER
    log_success "Passwordless sudo configured"
else
    log_info "Skipping passwordless sudo configuration"
fi

# 1. Install Base Dependencies
log_info "Installing base dependencies..."
sudo apt update
sudo apt install -y \
    ack-grep \
    build-essential \
    curl \
    fd-find \
    git \
    golang-go \
    imagemagick \
    iputils-ping \
    liblldb-18 \
    libssl-dev \
    lldb-18 \
    locales \
    luarocks \
    ncurses-bin \
    pkg-config \
    python3 \
    python3-dev \
    python3-lldb-18 \
    python3-pip \
    python3-pynvim \
    python3-venv \
    ripgrep \
    tmux \
    unzip \
    vim \
    wget \
    xclip
log_success "Base dependencies installed"

# Configure locale
log_info "Configuring locale..."
sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8
log_success "Locale configured"

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

# Install cargo-binstall for faster binary installations
if ! command -v cargo-binstall &>/dev/null; then
    log_info "Installing cargo-binstall..."
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    log_success "cargo-binstall installed"
else
    log_info "cargo-binstall already installed"
fi

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

# Install tmux-sessionizer
if ! command -v tmux-sessionizer &>/dev/null; then
    log_info "Installing tmux-sessionizer..."
    if command -v cargo-binstall &>/dev/null; then
        cargo binstall -y tmux-sessionizer
    else
        cargo install tmux-sessionizer
    fi
    log_success "tmux-sessionizer installed"

    # Create projects directory for tmux-sessionizer
    if [[ ! -d "$HOME/projects/active" ]]; then
        log_info "Creating ~/projects/active directory..."
        mkdir -p "$HOME/projects/active"
        log_success "Projects directory created"
    fi
else
    log_info "tmux-sessionizer already installed"
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

# 13. Install CMake and build tools (Optional)
read -p "Do you want to install cmake and gettext for building from source? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing cmake and gettext..."
    sudo apt install -y cmake gettext
    log_success "cmake and gettext installed"
else
    log_info "Skipping cmake and gettext installation"
fi

# 14. Install nvm and Node.js (Optional)
read -p "Do you want to install nvm and Node.js? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    export NVM_DIR="$HOME/.config/nvm"
    if [[ ! -d "$NVM_DIR" ]]; then
        log_info "Installing nvm to $NVM_DIR..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # Source nvm to use it immediately
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

        log_success "nvm installed"

        log_info "Installing Node.js LTS..."
        nvm install --lts
        log_info "Installing latest Node.js..."
        nvm install node
        log_success "Node.js installed"

        # Install npm global packages
        log_info "Installing npm global packages..."
        npm install -g @anthropic-ai/claude-code opencode-ai
        log_success "npm global packages installed"
    else
        log_info "nvm already installed at $NVM_DIR"
    fi
else
    log_info "Skipping nvm and Node.js installation"
fi

# 15. Install Neovim (Optional)
read -p "Do you want to install Neovim (prebuilt binary)? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v nvim &>/dev/null; then
        log_info "Installing Neovim..."
        mkdir -p "$HOME/.local/bin"
        NVIM_VERSION="v0.11.4"
        NVIM_TGZ="/tmp/nvim-linux-x86_64.tar.gz"
        curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" -o "$NVIM_TGZ"
        tar xzf "$NVIM_TGZ" -C /tmp
        cp -r /tmp/nvim-linux-x86_64/* "$HOME/.local/"
        rm -rf /tmp/nvim-linux-x86_64 "$NVIM_TGZ"
        log_success "Neovim installed"
    else
        log_info "Neovim already installed"
    fi
else
    log_info "Skipping Neovim installation"
fi

# 16. Setup Python virtualenv for Neovim (Optional)
read -p "Do you want to setup Python virtualenv for Neovim? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -d "$HOME/venv" ]]; then
        log_info "Setting up Python virtualenv for Neovim..."
        python3 -m venv "$HOME/venv"
        "$HOME/venv/bin/pip" install --upgrade pip
        "$HOME/venv/bin/pip" install pynvim
        log_success "Python virtualenv for Neovim created"
    else
        log_info "Python virtualenv already exists at ~/venv"
    fi
else
    log_info "Skipping Python virtualenv setup"
fi

# 17. Install kubectl (Optional)
read -p "Do you want to install kubectl? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v kubectl &>/dev/null; then
        log_info "Installing kubectl..."
        mkdir -p "$HOME/.local/bin"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        mv kubectl "$HOME/.local/bin/"
        log_success "kubectl installed"
    else
        log_info "kubectl already installed"
    fi
else
    log_info "Skipping kubectl installation"
fi

# 18. Clone Neovim configuration (Optional)
read -p "Do you want to clone your Neovim configuration? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ ! -d "$HOME/.config/nvim" ]]; then
        log_info "Cloning Neovim configuration..."
        git clone https://github.com/mhalder/nvim.git "$HOME/.config/nvim"
        log_success "Neovim configuration cloned"
    else
        log_info "Neovim configuration already exists at ~/.config/nvim"
    fi
else
    log_info "Skipping Neovim configuration clone"
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
