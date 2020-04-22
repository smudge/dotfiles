#!/bin/bash

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
rustup component add rustfmt rls rust-analysis rust-src
gem install solargraph
vim +'PlugInstall --sync' +qa
vim +'CocInstall coc-rls coc-solargraph coc-tsserver coc-tslint-plugin' +qa
