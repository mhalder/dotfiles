#!/bin/bash
git clone --quiet https://github.com/junegunn/fzf.git ~/.fzf
git clone --quiet https://github.com/junegunn/fzf-git.sh.git ~/.fzf-git
~/.fzf/install --no-bash --no-zsh --no-update-rc > /dev/null 2>&1
