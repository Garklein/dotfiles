{ pkgs, lib, inputs, ... }:

{
  imports = [
    modules/wm.nix
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    kernelPackages = pkgs.linuxPackages_5_15;
    tmp.cleanOnBoot = true;
  };

  networking = {
    hostName = "bog";
    networkmanager.enable = true;
  };

  # let me shebang
  services.envfs.enable = true;

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  zramSwap.enable = true;

  programs.nix-ld.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # see battery info
  services.upower.enable = true;

  # mount ios devices
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  users.users.gator = {
    isNormalUser = true;
    description = "gator";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
