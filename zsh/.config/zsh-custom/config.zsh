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

# enable fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d ~/.fzf-git ] && source ~/.fzf-git/fzf-git.sh

# githelpers
[ -f ~/.githelpers ] && source ~/.githelpers

# zsh plugins
source ${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# uv (only if uv is installed)
command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion zsh)"

# X11/GUI specific commands (only in graphical sessions)
if [ -n "$DISPLAY" ]; then
  # prevent terminal go black and picom
  command -v xset >/dev/null 2>&1 && xset s off
  command -v xset >/dev/null 2>&1 && xset s noblank
  command -v xset >/dev/null 2>&1 && xset -dpms
  command -v gsettings >/dev/null 2>&1 && gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null
  command -v picom >/dev/null 2>&1 && (pgrep picom >/dev/null || picom -b)
fi

# nvim helpers
alias nvim-claude="NVIM_APPNAME=nvim-claude nvim"
function nvims() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is not installed"
    return 1
  fi
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
  if ! command -v yazi >/dev/null 2>&1; then
    echo "yazi is not installed"
    return 1
  fi
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Initialize Starship prompt (only if starship is installed)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
