# set default editor
export EDITOR='nvim'
export VISUAL='nvim'

# switch of annoying beep
setopt nobeep

# list choices of completion
setopt autolist

# exit shell with background jobs
setopt nocheckjobs
setopt nohup

# use vv instead of esc for vim mode
bindkey -v

# enable fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"
[ -d ~/.fzf-git ] && source ~/.fzf-git/fzf-git.sh

# githelpers
[ -f ~/.githelpers ] && source ~/.githelpers

# forgit
# source <(curl -sSL git.io/forgit)

# kubectl
source <(kubectl completion zsh)

# zsh plugins
source ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# go
export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin
export GOPATH=$HOME/go

# zoxide
eval "$(zoxide init zsh)"
alias cd=z

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# cargo
source "$HOME/.cargo/env"

# julia
path=('/home/halderm/.juliaup/bin' $path)
export PATH

# console-ninja
PATH=~/.console-ninja/.bin:$PATH

# uv
eval "$(uv generate-shell-completion zsh)"

# prevent terminal go black and picom
xset s off
xset s noblank
xset -dpms
gsettings set org.gnome.desktop.session idle-delay 0
pgrep picom >/dev/null || picom -b

# nvim helpers
alias nvim-claude="NVIM_APPNAME=nvim-claude nvim"
function nvims() {
  items=("default" "nvim-claude" "clean")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  elif [[ $config == "clean" ]]; then
    unset "items[-1]"
    clean=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config " --height=~50% --layout=reverse --border --exit-0)
    if [[ -n $clean ]]; then
      echo cleaning $clean
      if [[ $clean == "default" ]]; then
        clean="nvim"
      fi
      rm -rf ~/.local/share/$clean
      rm -rf ~/.local/state/$clean
      rm -rf ~/.cache/$clean
    fi
    return 0
  fi
  NVIM_APPNAME=$config nvim $@
}

# yazi helpers
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
