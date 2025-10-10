# zshrc
alias zshrc='nvim ~/.zshrc'

# rescale backgroun image
alias back='bash -c "feh --bg-scale ~/.background.png"'

# directory ops
alias s='cd ..'
alias ss='cd ../..'
alias e='exit'
alias se='source .env'

# vim
alias v='nvim '
alias vi='nvim '
alias vs='nvim .git/index'
alias vim='nvim '
alias vc='cd $HOME/.config/nvim'

# clear
alias c='clear'
alias cl='clear; l'

# git
alias gac='git update-index --assume-unchanged'
alias ganc='git update-index --no-assume-unchanged'
alias sac='git ls-files -v | grep "^[[:lower:]]"'
alias g='pretty_git_log'
alias glog='clear && git --no-pager log --oneline --graph --decorate -n 20'
alias gloga='clear && git --no-pager log --oneline --graph --decorate --all -n 30'

# finding grep
find_function() {
  find . -name "*$1*"
}
alias afind='ack -il'
alias ffind='find_function'

# docker containers
alias drc='docker rm -f $(docker ps -a -q)'
alias dri='docker rmi -f $(docker images -q)'
alias lz='lazygit'
alias lzd='lazydocker'

# clipboard
alias pbcopy='xclip -selection clipboard'

# weather
alias weather='curl v2.wttr.in'

# kube
alias kx='kubectx'
alias kk='k9s'
alias kc='cd $HOME/.local/state/k9s/screen-dumps && tree'
alias kn='kubens'

# tmux
alias t='tmux'
alias tt='tmux attach'

# eza
alias l="eza --long --sort=modified --reverse --no-user"

# jj
alias j='jj'
alias lj='lazyjj'
alias jst='jj st'
