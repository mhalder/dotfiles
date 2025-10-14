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

- [stau](https://github.com/mhalder/stau) - Dotfile manager
  - Install via: `cargo install stau`
  - Or build from source: `cargo build --release`

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

- **bash** - Bash shell configuration with custom aliases, functions, and prompt settings
- **zsh** - Z shell configuration featuring:
  - Powerlevel10k theme for enhanced prompt
  - Custom aliases and functions
  - Plugin management and integrations
  - History settings and completion enhancements
- **tmux** - Terminal multiplexer configuration with:
  - Custom key bindings
  - Status bar customization
  - Plugin management via TPM (Tmux Plugin Manager)
  - Mouse support and copy-paste improvements
- **terminal** - Terminal emulator settings including colors, fonts, and behavior

### Development Tools

- **git** - Version control configuration including:
  - Global gitconfig with aliases and settings
  - Git attributes and ignore patterns
  - Commit templates and merge strategies
- **gh** - GitHub CLI settings for streamlined GitHub workflows
- **fzf** - Fuzzy finder configuration with custom key bindings and integration with shell history
- **lazy** - LazyGit and LazyVim configurations for efficient git workflows and Neovim setup
- **bin** - Custom scripts and executables for automation and workflows

### System Tools

- **atuin** - Advanced shell history management with:
  - Cross-shell history sync
  - Searchable command history
  - Privacy-focused settings
- **btop** - Resource monitor with customizable themes and layouts
- **dunst** - Lightweight notification daemon configuration with custom styling
- **i3** - Tiling window manager configuration including:
  - Custom key bindings
  - Workspace management
  - i3status bar configuration
  - Application-specific rules
- **yazi** - Modern terminal file manager with vim-like keybindings
- **k9s** - Kubernetes CLI tool configuration for cluster management

## Package Setup Scripts

Several packages include automated setup and teardown scripts for complete installation:

### Packages with Setup Scripts

- **fzf** - Clones fzf and fzf-git repositories, runs fzf installer
- **tmux** - Installs Tmux Plugin Manager (TPM) and plugins
- **zsh** - Sets up oh-my-zsh, Powerlevel10k theme, and custom plugins

These scripts ensure that when you install a package, all necessary dependencies are automatically installed and configured, making setup on new machines quick and painless.

## Usage

```bash
# Install stau
cargo install stau

# Clone repository
git clone <repository-url> ~/dotfiles

# Deploy packages
stau install <package-name>     # Install specific package
stau install zsh tmux git       # Install multiple packages
stau install --all              # Install all packages

# Manage packages
stau list                       # List available packages
stau status                     # Check installed packages
stau uninstall <package-name>   # Remove a package

# Advanced options
stau install --target ~/custom-dir <package>  # Custom target directory
STAU_DIR=~/my-dotfiles stau install <package> # Custom dotfiles location
```

### Migration from Existing Dotfiles

If you have existing dotfiles in your home directory:

```bash
# Adopt existing dotfiles into stau management
stau adopt <package-name>
```

This will move your existing config files into the package directory and create symlinks.

## License

This project is licensed under the BEER-WARE LICENSE. See the [LICENSE](LICENSE) file for details.

If you find these configs useful and we meet someday, you can buy me a beer!
