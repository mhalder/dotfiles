#!/bin/bash

if [ -d ~/.fzf ]; then
  git -C ~/.fzf pull --quiet
else
  git clone --quiet https://github.com/junegunn/fzf.git ~/.fzf
fi

if [ -d ~/.fzf-git ]; then
  git -C ~/.fzf-git pull --quiet
else
  git clone --quiet https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git
fi

~/.fzf/install --no-bash --no-zsh --no-update-rc >/dev/null 2>&1
