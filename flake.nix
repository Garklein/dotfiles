{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.bog = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        username = "gator";
        hostname = "bog";
      };
      modules = [
        ./modules/nixos
        ./hosts/bog/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
