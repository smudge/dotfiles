{ lib, ... }:

{
  imports = [
    ./cli.nix
    ./shell.nix
    ./tmux.nix
    ./nvim.nix
    ./theme.nix
    ./dev.nix
    ./ai.nix
    ./apps.nix
  ];

  options.my = {
    dev.enable = lib.mkEnableOption "development toolchains" // { default = true; };
    ai.enable = lib.mkEnableOption "AI coding tools" // { default = true; };
    apps.enable = lib.mkEnableOption "GUI applications" // { default = true; };
  };

  config = {
    programs.home-manager.enable = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. Override per-host if a machine was set up on an older one.
    home.stateVersion = lib.mkDefault "26.05";
  };
}
