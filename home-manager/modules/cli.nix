{ pkgs, lib, ... }:

let
  hostPlatform = pkgs.stdenv.hostPlatform;
  isWindowsHost = if hostPlatform ? isWindows then hostPlatform.isWindows else false;
in
{
  home.packages = with pkgs; [
    jq
    bat
    direnv
    eza
    fzf
    fd
    git
    gh
    ncdu
    ripgrep
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    wl-clipboard
    xclip
  ]
  ++ lib.optionals isWindowsHost [
    win32yank
  ];

  programs.autojump.enable = true;
  programs.autojump.enableBashIntegration = true;
}
