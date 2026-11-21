{ config, pkgs, lib, ... }:

lib.mkIf config.my.dev.enable {
  home.packages = with pkgs; [
    nodejs
    yarn
    rustup
    spirv-tools
    vulkan-validation-layers
  ];
}
