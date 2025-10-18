export LANG=en_US.UTF-8
export ZSH="$HOME/.oh-my-zsh"
export SHELL=/usr/bin/zsh
export ZSH_CUSTOM=$HOME/.config/zsh-custom

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# History settings - prevent sensitive commands from being saved
setopt HIST_IGNORE_SPACE    # Don't save commands starting with a space
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate commands
setopt HIST_SAVE_NO_DUPS    # Don't write duplicate entries
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks

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

# SSH agent configuration
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities id_rsa
zstyle :omz:plugins:ssh-agent lifetime 12h
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

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
