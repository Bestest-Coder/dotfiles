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
    #oom-unstable.url = "nixpkgs/<rev>";
    nixpkgs-testing.url = "path:/home/bestest/projects/nixpkgs";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, agenix, oom-hardware, nixpkgs-testing, ...}@attrs:
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
    #ienCrossPkgs = (import nixpkgs-unstable {system = "x86_64-linux";}).pkgsCross.aarch64-multiplatform;
    # I think same thing but more explicit
    ienCrossPkgs = (import nixpkgs-unstable {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    });
    crossKernelOverlay = final: prev: {
      inherit (ienCrossPkgs) linuxKernel linuxPackagesFor;
    };
    rpi4-allow-missing-overlay = final: prev: {
      makeModulesClosure = x:
        prev.makeModulesClosure (x // {allowMissing = true;});
    };
    overlay-gtk-fix = (final: prev: {
      qt6Packages = prev.qt6Packages.overrideScope (_: kprev: {
        qt6gtk2 = kprev.qt6gtk2.overrideAttrs (_: {
          version = "0.5-unstable-2025-03-04";
          src = final.fetchFromGitLab {
            domain = "opencode.net";
            owner = "trialuser";
            repo = "qt6gtk2";
            rev = "d7c14bec2c7a3d2a37cde60ec059fc0ed4efee67";
            hash = "sha256-6xD0lBiGWC3PXFyM2JW16/sDwicw4kWSCnjnNwUT4PI=";
          };
        });
      });
    });
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
          #oom-hardware.nixosModules.uconsole
          nixos-hardware.nixosModules.raspberry-pi-4
          { nixpkgs.overlays = [rpi4-allow-missing-overlay]; }
        ] ++ common-modules;# ++ home-manager-config (import ./nixos/hosts/ien/home.nix);
      };
      # needs to be built with --impure
      ienCross = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = attrs;
        modules = [
          ./nixos/hosts/ien/configuration.nix
          #oom-hardware.nixosModules.uconsole
          nixos-hardware.nixosModules.raspberry-pi-4
          { nixpkgs.overlays = [rpi4-allow-missing-overlay]; }
          "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image.nix"
          ./nixos/hosts/ien/sd-image.nix
        ] ++ common-modules;# ++ nixosConfigurations.ien.modules;
      };
    };
  ien-sd-image = nixosConfigurations.ienCross.config.system.build.sdImage;
  };
}
