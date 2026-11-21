{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g mouse on
      set -g status off
      set -ga terminal-overrides ',*256col*:Tc'
      set -g default-terminal "screen-256color"
      set -g set-clipboard on
      set-option -s escape-time 10
      set -ga update-environment " WAYLAND_DISPLAY WAYLAND_SOCKET XDG_RUNTIME_DIR"

      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -n C-S-Left previous-window
      bind -n C-S-Right next-window
    '';
  };
}
