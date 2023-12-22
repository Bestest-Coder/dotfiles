{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...}@attrs:
    let
      system = "x86_64-linux";
      # adds pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      overlayedPkgs = [({config, pkgs, ...}: {nixpkgs.overlays = [overlay-unstable]; })];
    in {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit home-manager; };
        modules = [./configuration.nix] ++ overlayedPkgs;
        #home-manager.nixosModules.home-manager
      };
    };
}
