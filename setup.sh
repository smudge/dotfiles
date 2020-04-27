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

# TODO: Install rust/cargo

# Set "Night Shift" default temp to 100
cargo install nightshift
nightshift temp 78
nightshift schedule

# Support for the Language Server Protocol
rustup component add rustfmt rust-src
rustup component remove rls rust-analysis
gem install solargraph
vim +'PlugInstall --sync' +qa
vim +'CocUninstall coc-rls' +qa
vim +'CocInstall coc-rust-analyzer coc-solargraph coc-tsserver coc-tslint-plugin' +qa
