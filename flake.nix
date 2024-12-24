{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland-pkg.url = "git+https://github.com/hyprwm/Hyprland?submodules=1#";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ...}@attrs:
    let
      system = "x86_64-linux";
      # adds pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
        #hyprland = final.unstable.hyprland;
        #xdg-desktop-portal-hyprland = final.unstable.xdg-desktop-portal-hyprland;
        #aquamarine = final.unstable.aquamarine;
      };
      #overlay-hyprland = final: prev: {
      #  hyprland_latest = hyprland-pkg.packages."x86_64-linux".hyprland;
      #  hyprland_portal_latest = hyprland-pkg.packages."x86_64-linux".xdg-desktop-portal-hyprland;
      #};
      common-modules = [
        ({config, pkgs, ...}: {nixpkgs.overlays = [overlay-unstable]; })
      ];
      # provides an easy way to import home-manager configs
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
            nixos-hardware.nixosModules.framework-16-7040-amd
          ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/hoid/home.nix);
        };

        # R-01 uconsole system
        ien = nixpkgs.lib.nixosSystem {
          system = "riscv64-linux";
          specialArgs = attrs;
          modules = [
            #"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-riscv64-qemu.nix"
            ./nixos/hosts/ien/configuration.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
        # ien image with the options to cross-compile an sd image
        ienCross = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = attrs;
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-riscv64-qemu.nix"
            ({nixpkgs, ...}:
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.hostPlatform.system = "riscv64-linux";
              nixpkgs.buildPlatform.system = system;
            })
            ./nixos/hosts/ien/configuration.nix
            #./nixos/hosts/ien/sd-image.nix
            #nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
      };
      # cross-compile ien sd card image with
      # nix build .#images.ien
      images.ien = nixosConfigurations.ienCross.config.system.build.sdImage;
    };
}
