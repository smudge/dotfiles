{ config, pkgs, lib, ... }:

lib.mkIf config.my.ai.enable {
  home.packages = with pkgs; [
    codex
    claude-code
    opencode
  ];
}
