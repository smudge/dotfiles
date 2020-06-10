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
        ripgrep
        tmux
        hasklig
        alacritty
        firefox
      ];
    };
  };
}
