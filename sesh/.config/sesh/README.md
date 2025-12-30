# sesh

A smart tmux session manager with zoxide integration.

## Installation

```bash
go install github.com/joshmedeski/sesh/v2@latest
```

## Configuration

Config file: `~/.config/sesh/sesh.toml`

```toml
# Show last 2 path components (e.g., "active/my-project")
dir_length = 2

# Exclude directories
blacklist = ["node_modules", "target", ".git", "vendor", "build", "dist"]

# Sort order
sort_order = ["config", "tmux", "zoxide"]

# Default session settings
[default_session]
startup_command = "nvim"
preview_command = "eza --all --git --icons --color=always {}"

# Named sessions
[[session]]
name = "dotfiles"
path = "~/.config/dotfiles"
```

## Commands

| Command               | Description                       |
| --------------------- | --------------------------------- |
| `sesh list`           | List all sessions (tmux + zoxide) |
| `sesh list -t`        | Tmux sessions only                |
| `sesh list -c`        | Configured sessions only          |
| `sesh list -z`        | Zoxide directories only           |
| `sesh connect <name>` | Connect/create session            |
| `sesh last`           | Switch to previous session        |
| `sesh root`           | Get git project root              |
| `sesh preview <name>` | Preview a session                 |

## Keybinding

In `~/.config/tmux/tmux.conf`:

```tmux
bind f display-popup -E -w 80% -h 70% "sesh connect \"$(sesh list --icons | fzf --no-sort --ansi --prompt '⚡ ' --preview 'sesh preview {}')\""
```

Press `<prefix> f` to open the session picker.

## Links

- [GitHub](https://github.com/joshmedeski/sesh)
