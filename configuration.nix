{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bog"; # Define your hostname.

  # let me shebang
  services.envfs.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  zramSwap.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;

    windowManager.session = lib.singleton {
      name = "exwm";
      start = "${pkgs.emacs-gtk}/bin/emacs";
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-session -x ${config.services.displayManager.sessionData.desktops}/share/xsessions";
        user = "greeter";
      };
    };
  };
  environment.systemPackages = [ pkgs.emacs-gtk ];
  nixpkgs.overlays = [
    (final: prev: {
      emacs-gtk = prev.emacs-gtk.overrideAttrs (old: {
        patches = old.patches ++ [ patches/borders-respect-alpha-background.patch ];
      });
    })
  ];


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
  };

  users.users.gator = {
    isNormalUser = true;
    description = "gator";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.extraRules = [{
    users = [ "gator" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gator" = import ./home.nix;
    };

    # allow unfree packages for home manager
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
