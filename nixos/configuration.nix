# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Because nvidia:
  nixpkgs.config.allowUnfree = true;

  # Because intel:
  hardware.cpu.intel.updateMicrocode = true;

  # Support NTFS:
  boot.supportedFilesystems = [ "ntfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
  };

  # Use boot spinner
  boot.kernelParams = ["quiet"];
  boot.plymouth.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "smudge-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set your time zone.
  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };

  # Disable the NixOS documentation app.
  documentation.nixos.enable = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.sessionVariables = {
    # Fix invisible cursors on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint to electron apps that they should use Wayland
    NIXOS_OZONE_WL = "1";
  };

  programs = {
    # Enable the hyprland compositor (for Wayland)
    hyprland.enable = true;

    firefox.nativeMessagingHosts.packages = [
      pkgs.gnome-browser-connector
    ];
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "libsecret";
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Steam controller support
  hardware.steam-hardware.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable sound.
  sound.enable = false; # only for ALSA, setting pipewire below
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    wireplumber.extraConfig = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.xserver.excludePackages = [ pkgs.xterm ];

  # support trackpads.
  services.libinput.enable = true;
  services.touchegg.enable = true;

  # Set a faster key repeat.
  services.xserver = {
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable GNOME core utilities.
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  # Enable lorri: a wrapper for direnv and nix-shell
  # services.lorri.enable = true;

  # System packages (installed globally)
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Hyprland:
    networkmanagerapplet
    waybar
    dunst
    kitty
    libnotify
    rofi-wayland
    wl-clipboard

    xclip # for neovim clipboard
    firefox
    alacritty
    gnome.nautilus
    gnome.gnome-disk-utility
    gnome.gnome-system-monitor
    gnome.gnome-screenshot
    gnome.evince
    gnome.totem
    gedit
    gnome.eog
    gnome.baobab
    gnome.file-roller
    touchegg
    libinput-gestures
    # direnv
    # wget

    # Missing GNOME features:
    gnomeExtensions.x11-gestures # basic gestures
    gnomeExtensions.gesture-improvements # better gestures
    gnomeExtensions.desktop-icons-ng-ding # desktop icons
    gnomeExtensions.appindicator # tray icons

    # Display workspaces correctly
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
  ];

  # Some additional built-in fonts:
  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # More Hyprland:
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    # wlr.enable = true;
    # lxqt.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.smudge = {
    isNormalUser = true;
    description = "Nathan Griffith";
    extraGroups = [ "networkmanager" "wheel" "lp" "input" ];
    packages = with pkgs; [
      home-manager
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
