{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "Adwaita-dark";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
