{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ...}@attrs:
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
      ];
      home-manager-config = toplevel: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bestest = toplevel;
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
          ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/hoid/home.nix);
        };

        # uconsole system
        ien = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
            ({nixpkgs, ...}:
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.hostPlatform.system = "riscv64-linux";
              nixpkgs.buildPlatform.system = system;
              nixpkgs.crossSystem = {
                system = "riscv64-linux";
                #libc = "musl";
                #config = "riscv64-unknown-linux-musl";
              };
            })
            ./nixos/hosts/ien/configuration.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
      };
      # build ien sd card image with
      # nix build .#images.ien
      images.ien = nixosConfigurations.ien.config.system.build.sdImage;
    };
}
