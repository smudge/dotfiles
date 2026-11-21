{ config, pkgs, lib, ... }:

lib.mkIf config.my.apps.enable {
  home.packages = with pkgs; [
    hasklig
    alacritty
    firefox
    discord
    obsidian
    tiled
    ludusavi
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    rescuetime
    (wine.override { wineBuild = "wine64"; })
  ];
}
