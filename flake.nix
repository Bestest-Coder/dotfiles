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
    oom-hardware.url = "github:robertjakub/oom-hardware";
    gimp3-pkgs.url = "github:jtojnar/nixpkgs/gimp-meson";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, agenix, oom-hardware, gimp3-pkgs, ...}@attrs:
  let
    system = "x86_64-linux";
    # adds pkgs.unstable
    overlay-unstable-sub = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
    overlay-gimp = final: prev: {
      gimp3 = (import gimp3-pkgs {
        system = prev.system;
      }).gimp;
    };
    common-modules = [
      { nixpkgs.overlays = [overlay-unstable-sub]; }
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
      # this (and the nixpkgs module below) allow for just this system to run entirely on unstable nixpkgs
      # which is needed for hyprland latest to work because mesa
      hoid = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          {nixpkgs.config.pkgs = import nixpkgs-unstable {inherit system; config.allowUnfree = true;};}
          {nixpkgs.overlays = [overlay-gimp];}
          ./nixos/hosts/hoid/configuration.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
        ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/hoid/home.nix);
      };
      # home server
      urithiru = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          ./nixos/hosts/urithiru/configuration.nix
        ] ++ common-modules ++ home-manager-config (import ./nixos/hosts/urithiru/home.nix);
      };
      # uConsole (rpi cm4)
      ien = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [
          ./nixos/hosts/ien/configuration.nix
          oom-hardware.nixosModules.uconsole
        ] ++ common-modules;# ++ home-manager-config (import ./nixos/hosts/ien/home.nix);
      };
      # needs to be built with --impure
      ienCross = nixpkgs-unstable.lib.nixosSystem {
        #system = "x86_64-linux";
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [
          #{ nixpkgs.config.pkgs = import nixpkgs.pkgsCross.raspberryPi;}
          "${oom-hardware}/uconsole/sd-image-uConsole.nix"
          ./nixos/hosts/ien/configuration.nix
          oom-hardware.nixosModules.uconsole
        ] ++ common-modules;# ++ nixosConfigurations.ien.modules;
      };
    };
  ien-sd-image = nixosConfigurations.ienCross.config.system.build.sdImage;
  };
}
