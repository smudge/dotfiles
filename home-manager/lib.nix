{ self, nixpkgs, home-manager, ... }:

{
  username,
  system,
  homeDirectory ? null,
  modules ? [],
}:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  defaultHome =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    self.homeModules.default
    {
      home.username = username;
      home.homeDirectory =
        if homeDirectory != null then homeDirectory else defaultHome;
    }
  ] ++ modules;
}
