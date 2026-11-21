# Per-host home-manager flake.
#
# This file lives (uncommitted) at ~/.config/home-manager/flake.nix and holds
# everything specific to this machine/home. Apply with:
#
#   home-manager switch
#
# Pull in upstream changes with:
#
#   nix flake update && home-manager switch

{
  description = "Per-host home-manager config";

  inputs = {
    dotfiles.url = "github:smudge/dotfiles?dir=home-manager";

    # Optional: on a smudgenix host, share the system's pinned nixpkgs (from
    # /etc/nixos/flake.lock) instead of locking a separate one:
    # system.url = "path:/etc/nixos";
    # dotfiles.inputs.nixpkgs.follows = "system/nixos/nixpkgs";
  };

  outputs = { dotfiles, ... }: {
    homeConfigurations."@username@" = dotfiles.lib.mkHome {
      username = "@username@";
      system = "@system@";
      modules = [
        ({ config, pkgs, lib, ... }: {
          # Host-specific overrides & additions go here, e.g.:
          # my.ai.enable = false;
          # home.packages = [ pkgs.hello ];
        })
      ];
    };
  };
}
