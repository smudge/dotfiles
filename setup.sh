#!/bin/bash

defaults write -g InitialKeyRepeat -int 12 # default is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # default is 2 (30 ms)

brew bundle

# Install the latest node version:
LATEST_NODE=$(nodenv install --list | sort -rn | head -n 1)
nodenv install -s $LATEST_NODE
nodenv global $LATEST_NODE

# TODO: Install dotfiles, warn about overwriting changes
# TODO: Source installed dotfiles

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install tmux plugins (needs a tmux session to attach to)
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh

# Support for the Language Server Protocol
rustup component add rustfmt rust-src
rustup component remove rls rust-analysis
gem install solargraph
vim +'PlugUpgrade' +qa
vim +'PlugUpdate' +qa
vim +'PlugInstall --sync' +qa
vim +'CocUninstall coc-rls' +qa
vim +'CocInstall coc-rust-analyzer coc-solargraph coc-tsserver coc-tslint-plugin' +qa
