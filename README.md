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

- Linux system
- Git
- [stau](https://github.com/mhalder/stau)

## Quick Start

```bash
# Clone repository
git clone git@github.com:mhalder/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles

# Inspect available packages
stau list

# Install selected packages
stau install fish tmux git ghostty
stau install sway swaylock waybar mako kanshi satty lan-mouse xdg-desktop-portal autostart
```

Install packages incrementally. Each package symlinks its files into `$HOME` and may run optional `setup.sh` / `teardown.sh` hooks.

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
  - HashiCorp Vault integration with auto-renewal utility (`vault-renew`)
  - Bluetooth Corne keyboard connection scripts (`bt-corne`, `bt-corne-pair`) with multi-variant support (`--choc`/`--mx`), retry logic, and D-Bus agent for BLE pairing
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

### System Tools

- **btop** - Resource monitor with customizable themes and layouts
- **mako** - Lightweight Wayland notification daemon configuration for sway sessions
- **kanshi** - Dynamic display profile management for sway/wlroots outputs
- **sway** - Wayland compositor configuration with workspace bindings, idle handling, screenshots, and app launchers
- **wofi** - Wayland app launcher/picker configuration with combined `drun` and `dmenu` modes
- **swaylock** - Lock screen styling for sway sessions
- **waybar** - Top bar modules and styling for Wayland sessions
- **satty** - Annotated screenshot workflow for Wayland
- **lan-mouse** - Cross-device keyboard/mouse sharing config
- **xdg-desktop-portal** - Portal backend preferences for file pickers, screenshots, screencasts, and screen sharing on Wayland
- **autostart** - XDG autostart entries for GUI apps launched at login
- **yazi** - Modern terminal file manager with vim-like keybindings, Tokyo Night theme, zoxide integration, archive previews via ouch, Wayland clipboard support via `wl-copy`, and Sway-friendly openers (`xdg-open`, `mpv`)
- **k9s** - Kubernetes CLI tool configuration for cluster management
- **containers** - Container registry configuration for Podman/Docker

## Package Setup Scripts

All packages include `setup.sh` and `teardown.sh` scripts that run during install and uninstall:

- Simple packages verify the tool is installed and exit
- Complex packages handle additional setup (e.g., plugin installation, completions, dependencies)

Notable setup scripts:

- **fish** - Installs fzf binary, Fisher plugin manager, and syncs fish plugins
- **tmux** - Installs Tmux Plugin Manager (TPM) and plugins
- **sesh** - Verifies sesh is available (managed via mise)
- **mise** - Installs all configured runtimes and CLI tools, generates fish completions
- **fnox** - Configures Vault token and generates fish completions
- **jj** - Generates fish completions
- **yazi** - Installs yazi plugins (zoxide, ouch), Tokyo Night flavor, system dependencies (`wl-copy`, `mpv`, `7zz`), and uses mise for rust tools (`cargo:ouch`, `zoxide`)
- **wofi** - Verifies `wofi` is installed and cleans up Wofi cache files during teardown

These scripts run automatically during `stau install` and `stau uninstall`.

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

Use `stau help` for advanced options.

## License

This project is licensed under the BEER-WARE LICENSE. See the [LICENSE](LICENSE) file for details.

If you find these configs useful and we meet someday, you can buy me a beer!
