{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bog"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # let me shebang
  services.envfs.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
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
  nixpkgs.overlays = [
    (final: prev: {
      emacs = prev.emacs.overrideAttrs (old: {
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gator = {
    isNormalUser = true;
    description = "gator";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.extraRules = [{
    users = [ "gator" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gator" = import ./home.nix;
    };

    # allow unfree packages
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

  nix.settings.experimental-features =
    [ "nix-command"
      "flakes"
    ];
}
