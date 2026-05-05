{ pkgs, lib, inputs, ... }:

{
  imports = [
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

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  zramSwap.enable = true;

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

  # services.nginx = {
  #   enable = true;
  #   virtualHosts.localhost = {
  #     locations."/" = {
  #       root = "/var/www/docs";
  #       tryFiles = "$uri $uri/ $uri/index.html $uri.html";
  #     };
  #   };
  # };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gator" = import ../home;
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
