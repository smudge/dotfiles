# TODO: Install dotfiles, warn about overwriting changes
# TODO: Source installed dotfiles

nix-env -u
nix-env -i all

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install tmux plugins (needs a tmux session to attach to)
tmux source ~/.tmux.conf

# Support for the Language Server Protocol
rustup install stable
rustup default stable
rustup component add rustfmt rls rust-analysis rust-src
nvim +'PlugInstall --sync' +qa
nvim +'CocInstall coc-rls' +qa
