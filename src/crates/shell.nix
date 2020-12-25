let
  unstable = import (builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in

with nixpkgs; stdenv.mkDerivation {
  name = "rust-env";
  buildInputs = [
    nixpkgs.latest.rustChannels.nightly.rust
    unstable.rust-analyzer
    unstable.rustfmt
    glib.dev
    dbus
    pkgconfig
  ];
}
