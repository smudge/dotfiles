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
        nodejs
        ripgrep
        tmux
        hasklig
        alacritty
        firefox
      ];
    };
  };
}
