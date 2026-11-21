{ config, pkgs, lib, ... }:

lib.mkIf config.my.ai.enable {
  home.packages = with pkgs; [
    claude-code
    opencode
  ];
}
