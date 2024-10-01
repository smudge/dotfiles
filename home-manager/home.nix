{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "smudge";
  home.homeDirectory = "/home/smudge";

  wayland.windowManager.hyprland.enable = true;
  programs.waybar.enable = true;

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "nm-applet --indicator"
      "waybar"
      "dunst"
      "tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE \"$HYPRLAND_INSTANCE_SIGNATURE\""
    ];
    general = {
      gaps_in = 4;
      gaps_out = 8;
    };
    decoration = {
      rounding = 4;
      active_opacity = 1;
      inactive_opacity = 0.9;
      dim_inactive = true;
      dim_strength = 0.1;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_min_fingers = 3;
      workspace_swipe_min_speed_to_force = 15;
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };
    input = {
      touchpad = {
        natural_scroll = true;
        "tap-to-click" = true;
        clickfinger_behavior = true;
      };
    };
    monitor=
      [
        ",preferred,auto,1"
        "Unknown-1,disable"
      ];
    "$mod" = "SUPER";
    bind =
      [
        "$mod, S, exec, pkill waybar || waybar"
        "$mod, A, exec, rofi -show drun -show-icons"
        "$mod, Q, exec, alacritty"
        "$mod, B, exec, firefox"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };

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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
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
    pkgs.wine64
    pkgs.tiled
    pkgs.discord
    # pkgs.obsidian - version of electron is insecure

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
    # EDITOR = "emacs";
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
  # programs.autojump.enableBashIntegration = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
