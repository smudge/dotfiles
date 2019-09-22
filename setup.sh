#!/bin/bash

brew bundle

rustup component add rustfmt rls rust-analysis rust-src

# TODO: Install dotfiles, warn about overwriting changes

vim +'PlugInstall --sync' +qa
