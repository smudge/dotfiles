{
  packageOverrides = pkgs: with pkgs; {
    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        autojump
        bat
        exa
        fzf
        git
        ncdu
        neovim
        patchutils
        ripgrep
        rustup
        tmux
        nodejs
        ruby
        hasklig
        alacritty
        firefox
      ];
    };
  };
}
