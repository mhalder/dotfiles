export LANG=en_US.UTF-8
export PATH=$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export SHELL=/usr/bin/zsh
export ZSH_CUSTOM=$HOME/.config/zsh-custom

ZSH_THEME="powerlevel10k/powerlevel10k"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# neofetch

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ${ZSH_CUSTOM}/pluginlist
source $ZSH/oh-my-zsh.sh

if ! pgrep -x parcellite >/dev/null; then
    nohup parcellite >/dev/null 2>&1 &
fi

if [[ -z "$TMUX" ]]; then
    tmux
fi

export GTK_THEME=Adwaita-dark
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export VIRTUAL_ENV=$HOME/venv
source $VIRTUAL_ENV/bin/activate
