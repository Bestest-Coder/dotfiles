{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, agenix, ...}@attrs:
    let
      system = "x86_64-linux";
      # adds pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };
      common-modules = [
        ({config, pkgs, ...}: {nixpkgs.overlays = [overlay-unstable]; })
        agenix.nixosModules.default
        { environment.systemPackages = [ agenix.packages.${system}.default ]; }
      ];
      # provides an easy way to import home-manager configs
      home-manager-config = toplevel: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bestest = toplevel;
          home-manager.backupFileExtension = "backup";
        }
      ];
    in rec {
      nixosConfigurations = {
        # framework 16 system
        hoid = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            ./nixos/hosts/hoid/configuration.nix
            nixos-hardware.nixosModules.framework-16-7040-amd
          ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/hoid/home.nix);
        };
      urithiru = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          ./nixos/hosts/urithiru/configuration.nix
        ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/urithiru/home.nix);
      };
    };
  };
}
