{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "smudge";
  home.homeDirectory = "/home/smudge";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.jq # Scripting on top of Hyprland
    pkgs.autojump
    pkgs.bat
    pkgs.direnv
    pkgs.eza
    pkgs.fzf
    pkgs.git
    pkgs.neovim
    pkgs.nodejs
    pkgs.rescuetime
    pkgs.ripgrep
    pkgs.rustup
    pkgs.tmux
    pkgs.yarn
    pkgs.hasklig
    pkgs.alacritty
    pkgs.firefox
    pkgs.ludusavi
    pkgs.tiled
    pkgs.discord
    pkgs.obsidian

    pkgs.spirv-tools
    pkgs.vulkan-validation-layers

    (pkgs.wine.override { wineBuild = "wine64"; })

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/smudge/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza";
      cat = "bat --paging=never --style=plain";
      du = "ncdu --color dark -rr -x --exclude .git --exclude node_modules";
      j = "autojump";
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

  # Enable autojump
  programs.autojump.enable = true;
  programs.autojump.enableBashIntegration = true;

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "Adwaita-dark";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
