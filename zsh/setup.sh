#!/bin/bash
mkdir -p ~/.config/zsh-custom/themes
mkdir -p ~/.config/zsh-custom/plugins
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/romkatv/powerlevel10k.git ~/.config/zsh-custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-custom/plugins/zsh-autosuggestions
