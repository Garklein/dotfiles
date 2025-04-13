{ config, pkgs, inputs, ... }:

{
  imports =
    [ inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bog"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # https://www.reddit.com/r/NixOS/comments/15mrrez/tuigreet_configuration_for_hyprland/
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
  #       # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
  #       user = "greeter";
  #     };
  #   };
  # };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.exwm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.picom.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gator = {
    isNormalUser = true;
    description = "gator";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
      vim alacritty discord neofetch easyeffects emacs30-pgtk unzip git feh openssl python3 perl alsa-utils
    ];
  };
  security.sudo.extraRules = [
    { users = [ "gator" ]
    ; commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }]
    ; }
  ];

  # services.emacs.package = pkgs.emacs-unstable;
  nixpkgs.overlays = [
    # (import (builtins.fetchTarball {
    #   url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    #   sha256 = "";
    # }))
    # (final: prev: {
    #   emacs = prev.emacs.overrideAttrs (old: {
    #     patches = old.patches ++ [ /home/gator/borders-respect-alpha-background.patch ];
    #   });
    # })
  ];

  # Install firefox.
  # programs.firefox.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gator" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  nix.settings.experimental-features =
    [ "nix-command"
      "flakes"
    ];
}
