{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
      # url = "path:/home/gator/dormant/home-manager";
      url = "github:garklein/home-manager";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.bog = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        username = "gator";
        hostname = "bog";
      };
      modules = [
        ./modules/nixos
        ./hosts/bog/configuration.nix
        home-manager.nixosModules.default
      ];
    };

    homeConfigurations.home = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs;
        # don't forget to set these!
        username = "esue";
        hostname = "archlinux";
      };
      modules = [
        ./modules/home
      ];
    };
  };
}
