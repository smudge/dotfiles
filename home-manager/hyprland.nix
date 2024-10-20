{ self, pkgs, ... }:

{
  imports = [
    ./waybar.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    playerctl
    pamixer
    grimblast
    rofi-wayland
    libnotify
    dunst
    hyprlock
    waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "nm-applet --indicator"
        "waybar"
        "dunst"
        "tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE \"$HYPRLAND_INSTANCE_SIGNATURE\""
      ];
      layerrule = [
        "blur,rofi"
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
        repeat_rate = 50;
        repeat_delay = 300;

        accel_profile = "flat";
        follow_mouse = 1;
        sensitivity = 0;
        mouse_refocus = false;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          "tap-to-click" = false;
        };
      };
      monitor = [
        ",preferred,auto,1"
        "eDP-1,preferred,auto,2"
        "Unknown-1,disable"
      ];
      "$mod" = "SUPER";
      "$focusRofi" = "& while [ \"$(hyprctl clients | grep \"class: Rofi\")x\" == \"x\" ]; do continue; done; hyprctl dispatch focuswindow \"^(Rofi)\"";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, Control_L, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, ALT_L, resizewindow"
      ];
      bindel = [ # e = repeat when held, l = available on lock screen
        ", XF86AudioLowerVolume, exec, pamixer --decrease 5"
        ", XF86AudioRaiseVolume, exec, pamixer --increase 5"
        ", XF86MonBrightnessDown, exec, brillo -u 150000 -U 8"
        ", XF86MonBrightnessUp, exec, brillo -u 150000 -A 8"
      ];
      bindl = [ # l = available on lock screen
        ", XF86AudioMute, exec, pamixer --toggle-mute"
        ", XF86AudioMicMute, exec, pactl -- set-source-mute 0 toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      bind = [
        "$mod, Q, killactive,"
        "$mod, M, exec, pkill waybar || waybar"
        "$mod, A, exec, rofi -show drun -show-icons $focusRofi"
        "$mod, T, exec, alacritty"
        "$mod, B, exec, firefox"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        ", Print, exec, grimblast copy area"
        ", switch:on:Lid Switch, exec, if [[ $(hyprctl monitors -j | jq 'length') > 1 ]]; then hyprctl keyword monitor \"eDP-1,disable\"; hyprlock & disown && systemctl suspend; fi"
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1,preferred,auto,2\" && hyprctl dispatch dpms on"
      ] ++ (
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
  };
}
