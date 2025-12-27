# Fish Shell Cheatsheet

## fzf.fish
| Key | Action |
|-----|--------|
| `Ctrl+r` | Search command history |
| `Ctrl+Alt+f` | Search files |
| `Ctrl+Alt+l` | Search git log |
| `Ctrl+Alt+s` | Search git status |
| `Ctrl+Alt+p` | Search processes |
| `Ctrl+v` | Search variables |

## Zoxide
| Command | Action |
|---------|--------|
| `z foo` | Jump to directory matching "foo" |
| `zi foo` | Interactive selection with fzf |

## Custom
| Key/Abbr | Action |
|----------|--------|
| `Alt+e` | Edit command in nvim |
| `e` | exit |
| `v` | nvim |

## eza (ls replacement)
| Abbr | Expands to |
|------|------------|
| `l` | `eza` |
| `ls` | `eza` |
| `ll` | `eza -l` (long) |
| `la` | `eza -la` (long + hidden) |
| `lt` | `eza --tree` |
| `lta` | `eza --tree -a` (tree + hidden) |
