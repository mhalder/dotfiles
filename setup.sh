export STAU_DIR=$HOME/workspace/dotfiles

stau install btop --force
stau install fzf --force
stau install gh --force
stau install git --force
stau install jj --force
stau install k9s --force
stau install lazy --force
stau install oktofetch --force
stau install tmux --force
stau install yazi --force
stau install zsh --force
oktofetch update

# install tmux plugin manager (TPM) and plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "TPM already exists, skipping clone"
fi

# install tmux plugins via TPM
if [ -f ~/.tmux/plugins/tpm/bin/install_plugins ]; then
  ~/.tmux/plugins/tpm/bin/install_plugins
fi

# install nvm
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "nvm already exists, skipping installation"
fi

# install node 22
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 22
nvm alias default 22

# install claude cli
if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code
else
  echo "claude cli already installed, skipping"
fi

# install neovim
if ! command -v nvim &>/dev/null; then
  mkdir -p ~/.local/bin
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
  tar xzf nvim-linux-x86_64.tar.gz
  cp -r nvim-linux-x86_64/* ~/.local/
  rm -rf nvim-linux-x86_64 nvim-linux-x86_64.tar.gz
  cd -
else
  echo "neovim already installed, skipping"
fi

if [ ! -d ~/.config/nvim ]; then
  git clone https://github.com/mhalder/nvim.git ~/.config/nvim
else
  echo "nvim config already exists, skipping clone"
fi
