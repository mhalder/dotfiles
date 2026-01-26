# Dotfiles

Personal configuration files for a complete Linux development environment, providing a consistent and reproducible setup across machines.

## Overview

This repository contains configuration files and automated installation hooks for various development tools, shell environments, and system utilities. All configurations are managed using [stau](https://github.com/mhalder/stau), a modern dotfile manager written in Rust that combines GNU Stow-style symlink management with powerful setup automation.

### Key Features

- **Modular Configuration**: Each tool has its own directory, allowing selective deployment
- **Automated Setup**: Installation hooks handle dependencies and initial setup automatically
- **Version Controlled**: Track changes and roll back configurations easily
- **Portable**: Works across different Linux systems with minimal setup
- **Clean Organization**: Configurations stored in a central location, symlinked to their proper destinations

## Requirements

- Linux system (Ubuntu/Debian based distributions supported)
- Git
- curl or wget
- sudo privileges

> **Note**: The automated setup script will install all dependencies including Rust, Cargo, and stau.

## Quick Start

### Automated Installation

For a complete system setup on a fresh Linux installation, use the automated setup script:

```bash
# Clone the repository
git clone https://github.com/mhalder/dotfiles.git ~/dotfiles

# Run the automated setup
cd ~/dotfiles
./setup.sh
```

The setup script will:

- Configure passwordless sudo (optional)
- Install base system dependencies
- Set up Xorg and LightDM display manager (optional)
- Install and configure i3 window manager (optional)
- Install Ghostty terminal emulator (optional)
- Install Rust, Cargo, and development tools
- Install and configure stau dotfile manager
- Deploy all dotfiles packages
- Install Neovim with configuration
- Install nvm and Node.js with Claude Code CLI
- Set up zsh with oh-my-zsh and Powerlevel10k
- Install additional development tools

#### Configuration Options

The setup script can be configured via environment variables:

```bash
# Disable specific components
INSTALL_XORG_DESKTOP=false ./setup.sh
INSTALL_I3=false ./setup.sh
INSTALL_CHROME=false ./setup.sh

# Multiple options
INSTALL_GHOSTTY=false INSTALL_NEOVIM=false ./setup.sh
```

Available options (all default to `true`):

- `ENABLE_PASSWORDLESS_SUDO` - Configure passwordless sudo
- `INSTALL_XORG_DESKTOP` - Install Xorg and LightDM
- `INSTALL_I3` - Install i3 window manager
- `INSTALL_GHOSTTY` - Install Ghostty terminal
- `SET_ZSH_DEFAULT` - Set zsh as default shell
- `INSTALL_CASCADIA_FONTS` - Install Cascadia Code fonts
- `INSTALL_CHROME` - Install Google Chrome
- `INSTALL_UV` - Install uv Python package manager
- `INSTALL_CMAKE` - Install CMake and build tools
- `INSTALL_NVM` - Install nvm and Node.js
- `INSTALL_NEOVIM` - Install Neovim
- `SETUP_PYTHON_VENV` - Create Python virtualenv for Neovim
- `INSTALL_KUBECTL` - Install kubectl
- `CLONE_NVIM_CONFIG` - Clone Neovim configuration

### Manual Installation

For detailed manual installation steps, component-by-component installation, or if you prefer more control over the setup process, see the comprehensive [Installation Guide](ubuntu-installation.md).

## Structure

```
dotfiles/
├── <package>/      # Each tool has its own package directory
│   ├── config files
│   ├── setup.sh    # Optional installation script (runs after symlinking)
│   └── teardown.sh # Optional cleanup script (runs during uninstall)
└── Secrets/        # Sensitive configuration files (gitignored)
```

Each package directory contains:

- Configuration files that will be symlinked to your home directory
- Optional `setup.sh` script for post-installation tasks (e.g., installing plugins, dependencies)
- Optional `teardown.sh` script for cleanup when removing the package

Setup scripts receive these environment variables:

- `STAU_DIR`: Path to the dotfiles directory
- `STAU_PACKAGE`: Name of the current package
- `STAU_TARGET`: Target installation directory (default: `$HOME`)

> **Note**: `~/.background.png` is not included in this repository. You'll need to provide your own background image at this location.

## Included Configurations

### Shell & Terminal

- **fish** - Fish shell configuration with:
  - Fisher plugin manager and plugin sync
  - fzf binary installation and fzf.fish integration
  - Custom functions and aliases
- **tmux** - Terminal multiplexer configuration with:
  - Custom key bindings
  - Status bar customization
  - Plugin management via TPM (Tmux Plugin Manager)
  - Mouse support and copy-paste improvements
- **sesh** - Tmux session manager configuration with:
  - Zoxide integration for smart directory jumping
  - Configurable session startup commands
  - Directory blacklist for cleaner session lists
- **ghostty** - Ghostty terminal emulator configuration with:
  - TokyoNight theme
  - Cascadia Code font
  - Transparency and window decoration settings
  - Fish shell integration

### Development Tools

- **git** - Version control configuration including:
  - Global gitconfig with aliases and settings
  - Git attributes and ignore patterns
  - Commit templates and merge strategies
- **gh** - GitHub CLI settings for streamlined GitHub workflows
- **jj** - Jujutsu version control system configuration with custom aliases and workflows
- **lazy** - LazyGit and LazyVim configurations for efficient git workflows and Neovim setup
- **mise** - Runtime version manager for languages (Node, Python) and CLI tools with automatic activation
- **fnox** - Secrets manager with HashiCorp Vault integration for secure credential management
- **eza** - Modern ls replacement configuration with git integration and icons
- **ripgrep** - Fast search tool configuration

### AI & Automation

- **claude** - Claude Code CLI configuration including:
  - Custom agents for specialized tasks (architect, cloud, kubernetes, testing, documentation)
  - Skills for common workflows (commit, review-pr, ansible, terraform, etc.)
  - Hooks for automated suggestions and workflow improvements

### System Tools

- **btop** - Resource monitor with customizable themes and layouts
- **dunst** - Lightweight notification daemon configuration with custom styling
- **i3** - Tiling window manager configuration including:
  - Custom key bindings
  - Workspace management
  - i3status bar configuration
  - Application-specific rules
- **yazi** - Modern terminal file manager with vim-like keybindings, Tokyo Night theme, zoxide integration, and archive previews via ouch
- **k9s** - Kubernetes CLI tool configuration for cluster management
- **containers** - Container registry configuration for Podman/Docker

## What Gets Installed

The automated setup script installs a complete development environment including:

- **Base system**: Xorg, LightDM, i3 window manager
- **Terminal**: Ghostty terminal emulator
- **Languages**: Rust, Go, Python, Node.js (via nvm)
- **Editors**: Neovim with full configuration
- **Tools**: Git, GitHub CLI, kubectl, cargo tools, npm packages
- **Utilities**: Ripgrep, fd, btop, and many more

For the complete list of installed tools and system dependencies, see the [Installation Guide](ubuntu-installation.md).

## Package Setup Scripts

Several packages include automated setup scripts that run after symlinking:

### Packages with Setup Scripts

- **fish** - Installs fzf binary, Fisher plugin manager, and syncs fish plugins
- **tmux** - Installs Tmux Plugin Manager (TPM) and plugins
- **sesh** - Installs sesh binary via go install
- **yazi** - Installs yazi plugins (zoxide, ouch), Tokyo Night flavor, and system dependencies

These scripts are automatically executed by stau during package installation.

## Managing Packages

After installation, you can manage individual packages using stau:

```bash
# List packages
stau list                       # List available packages
stau status                     # Check installed packages

# Install/uninstall packages
stau install <package-name>     # Install specific package
stau install fish tmux git      # Install multiple packages
stau uninstall <package-name>   # Remove a package

# Adopt existing configs
stau adopt <package-name>       # Move existing config into stau management
```

For detailed usage instructions and advanced options, see the [Installation Guide](ubuntu-installation.md).

## License

This project is licensed under the BEER-WARE LICENSE. See the [LICENSE](LICENSE) file for details.

If you find these configs useful and we meet someday, you can buy me a beer!
