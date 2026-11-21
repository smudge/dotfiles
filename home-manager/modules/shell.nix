{ lib, ... }:

{
  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    BROWSER = lib.mkDefault "firefox";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza";
      cat = "bat --paging=never --style=plain";
      du = "ncdu --color dark -rr -x --exclude .git --exclude node_modules";
      vim = "nvim";
      vi = "nvim";
    };
    initExtra = ''
      if type tmux &>/dev/null; then
        if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "alacritty" ]; then
          [ -z "$TMUX"  ] && { exec tmux new-session && exit; }
        fi
      fi
    '';
    bashrcExtra = ''
     eval "$(direnv hook bash)"
    '';
  };
}
