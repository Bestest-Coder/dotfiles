{pkgs, ...}:
let
  overridePkgCFlags = pkg: flags:
    pkg.overrideAttrs (old:
      {
        NIX_CFLAGS_COMPILE = old.NIX_CFLAGS_COMPILE + "${flags}";
      });

  overlay-atomicfixes = final: prev: {
    glslang = prev.glslang.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = "-latomic";
    });
    cmake = prev.cmake.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE = "-latomic";
    });
    #binutils = prev.binutils.overrideAttrs (old: {
    #  NIX_CFLAGS_COMPILE = "-latomic";
    #});
  };

in
{
  imports = [
    ../../../configuration.nix
  ];

  nixpkgs.overlays = [overlay-atomicfixes];

  programs.neovim.withRuby = pkgs.lib.mkOverride 0 false;

  networking.hostName = "ien";

  networking.networkmanager.enable = pkgs.lib.mkOverride 0 false;

  environment.systemPackages = with pkgs; [
    tmux
    #vitetris
  ];
}
