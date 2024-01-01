{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, ...}:
    let
      system = "x86_64-linux";
      # adds pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      common-modules = [
        ({config, pkgs, ...}: {nixpkgs.overlays = [overlay-unstable]; })
        ./common-configuration.nix
      ];
      home-manager-config = toplevel: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bestest = toplevel;
        }
      ];
    in {
      nixosConfigurations.hoid = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/hoid/configuration.nix
        ] ++ common-modules ++ home-manager-config (import ./hosts/hoid/home.nix);

      };
    };
}
