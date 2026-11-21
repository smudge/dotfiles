#  flake.nix *
#   ├─ ./lib.nix          (mkHome)
#   ├─ ./modules
#   │   └─ default.nix    (opinionated home-manager defaults)
#   └─ ./template
#       └─ flake.nix      (per-host, uncommitted ~/.config/home-manager flake)

{
  description = "smudge's home-manager config, usable from any Nix-enabled home folder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    # nixvim pins (and is tested against) its own nixpkgs, so no `follows` here.
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs @ { self, nixvim, ... }: {
    # Build a homeConfiguration for a given user/system (see ./template).
    lib.mkHome = import ./lib.nix inputs;

    # The opinionated defaults, for composing manually.
    homeModules.default = {
      imports = [
        nixvim.homeModules.nixvim
        ./modules
      ];
    };

    # nix flake init -t github:smudge/dotfiles?dir=home-manager
    templates.default = {
      path = ./template;
      description = "Per-host home-manager flake (lives uncommitted in ~/.config/home-manager)";
    };
  };
}
