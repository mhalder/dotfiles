# Dotfiles

Personal configuration files for a complete Linux development environment, providing a consistent and reproducible setup across machines.

## Overview

This repository contains configuration files and automated installation hooks for various development tools, shell environments, and system utilities. All configurations are managed using [tuckr](https://github.com/RaphGL/tuckr), a symlink-based dotfile manager that keeps your home directory clean and organized.

### Key Features

- **Modular Configuration**: Each tool has its own directory, allowing selective deployment
- **Automated Setup**: Installation hooks handle dependencies and initial setup automatically
- **Version Controlled**: Track changes and roll back configurations easily
- **Portable**: Works across different Linux systems with minimal setup
- **Clean Organization**: Configurations stored in a central location, symlinked to their proper destinations

## Requirements

- [tuckr](https://github.com/RaphGL/tuckr) - Dotfile manager

## Structure

```
dotfiles/
├── Configs/        # Configuration files for various tools
├── Hooks/          # Installation hooks (pre, post, rm scripts)
└── Secrets/        # Sensitive configuration files (gitignored)
```

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

## Installation Hooks

The `Hooks/` directory contains automated installation scripts that run during configuration deployment. Each hook type serves a specific purpose:

- **`pre.sh`** - Runs before symlinking configuration files (e.g., backing up existing configs)
- **`post.sh`** - Runs after symlinking to complete setup (e.g., installing plugins, downloading dependencies)
- **`rm.sh`** - Runs when removing a configuration (e.g., cleaning up installed plugins)

### Currently Available Hooks

- **fzf** - Installs fzf binary and shell integrations
- **tmux** - Installs Tmux Plugin Manager (TPM) and plugins
- **zsh** - Sets up oh-my-zsh, Powerlevel10k theme, and custom plugins

These hooks ensure that when you deploy a configuration, all necessary dependencies are automatically installed and configured, making setup on new machines quick and painless.

## Usage

```bash
# Install tuckr (see https://github.com/RaphGL/tuckr)
cargo install tuckr

# Clone repository
git clone <repository-url> ~/.config/dotfiles

# Deploy configurations
tuckr add <config-name>  # Deploy specific config
tuckr add zsh tmux git   # Deploy multiple configs
tuckr add \*             # Deploy all configs

# Manage configurations
tuckr list               # List available configs
tuckr status             # Check deployed configs
tuckr rm <config-name>   # Remove a config
```

## License

This project is licensed under the BEER-WARE LICENSE. See the [LICENSE](LICENSE) file for details.

If you find these configs useful and we meet someday, you can buy me a beer!
