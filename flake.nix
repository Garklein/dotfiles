{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      # url = "github:nix-community/home-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
      # url = "path:/home/gator/dormant/home-manager";
      url = "github:garklein/home-manager";
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
        ./hosts/nixos/bog/configuration.nix
        home-manager.nixosModules.default
      ];
    };

    homeConfigurations.home = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs;
        username = "esue";
        hostname = "archlinux";
      };
      modules = [
        ./modules/home
        ./hosts/home/archlinux
      ];
    };
  };
}
