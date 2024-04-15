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

  services.dbus.implementation = "broker";

  documentation = {
    info.enable = false;
    dev.enable = false;
    nixos.enable = false;
  };

  programs.neovim.withRuby = pkgs.lib.mkOverride 0 false;
  programs.neovim.enable = pkgs.lib.mkOverride 0 false;
  programs.vim.defaultEditor = true;

  networking.hostName = "ien";

  networking.networkmanager.enable = pkgs.lib.mkOverride 0 false;

  environment.systemPackages = with pkgs; [
    tmux
    fbterm
    #vitetris
  ];

  #boot.loader.systemd-boot.enable = true;
}
