#!/bin/bash

defaults write -g InitialKeyRepeat -int 12 # default is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # default is 2 (30 ms)

brew bundle

# Set up my "Night Shift" defaults
nightlight temp 78
nightlight schedule start

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

# TODO: Install rust/cargo

# Support for the Language Server Protocol
rustup component add rustfmt rust-src
gem install solargraph
vim +'PlugUpgrade' +qa
vim +'PlugUpdate' +qa
vim +'PlugInstall --sync' +qa
vim +'CocInstall coc-solargraph coc-tsserver coc-tslint-plugin' +qa
