{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = {self, nixpkgs, home-manager, ...}@inputs: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix];
    };
  };
}
