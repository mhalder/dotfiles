export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export SHELL=/usr/bin/zsh
export ZSH_CUSTOM=$HOME/.config/zsh-custom

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Cargo environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Disable oh-my-zsh theme (using Starship instead)
ZSH_THEME=""

# FZF configuration (check multiple possible locations)
if [ -d "$HOME/.fzf" ]; then
    export FZF_BASE="$HOME/.fzf"
elif [ -d "/usr/share/fzf" ]; then
    export FZF_BASE="/usr/share/fzf"
elif [ -d "/usr/local/opt/fzf" ]; then
    export FZF_BASE="/usr/local/opt/fzf"
fi

# Configure plugin options before loading plugins
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent quiet yes

# Load plugins conditionally
if [ -f "${ZSH_CUSTOM}/pluginlist" ]; then
    source ${ZSH_CUSTOM}/pluginlist
else
    # Fallback minimal plugin list
    plugins=(git)
fi

[ -f "$ZSH/oh-my-zsh.sh" ] && source $ZSH/oh-my-zsh.sh

# Start parcellite if available and not running
if command -v parcellite >/dev/null 2>&1; then
    if ! pgrep -x parcellite >/dev/null 2>&1; then
        nohup parcellite >/dev/null 2>&1 &
    fi
fi

# Start tmux if available and not already in a session
if command -v tmux >/dev/null 2>&1; then
    if [[ -z "$TMUX" ]] && [[ -z "$VSCODE_INJECTION" ]]; then
        tmux
    fi
fi

export GTK_THEME=Adwaita-dark
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Virtual environment (only if exists)
if [ -d "$HOME/venv" ]; then
    export VIRTUAL_ENV=$HOME/venv
    source $VIRTUAL_ENV/bin/activate
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# jj completion (only if jj is installed)
command -v jj >/dev/null 2>&1 && source <(COMPLETE=zsh jj)
