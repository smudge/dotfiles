#!/bin/bash

brew bundle

# TODO: Install dotfiles, warn about overwriting changes

# Support for the Language Server Protocol
rustup component add rustfmt rls rust-analysis rust-src
gem install solargraph
vim +'PlugInstall --sync' +qa
vim +'CocInstall coc-rls' +qa
vim +'CocInstall coc-solargraph' +qa
