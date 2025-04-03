{pkgs, lib, ...}:
{
  imports = [
    ../../../configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ien";

  programs.labwc.enable = true;
  #programs.waybar.enable = true;
  #programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    #(callPackage ../../packages/twad {})
    kitty
    #firefox
    #libqalculate
    #qalculate-gtk
    #crispy-doom
    #fuzzel
  ];

  networking.networkmanager.enable = lib.mkForce false;
  system.stateVersion = lib.mkForce "25.05";

  #boot.loader.systemd-boot.enable = true;

  services.tailscale = {
    enable = true;
  };

  nix.buildMachines = [{
    hostName = "builder"; # actually hoid, but have alias in sshd
    systems = ["x86_64-linux" "aarch64-linux"];
    protocol = "ssh-ng";
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = ["big-parallel" "kvm"];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  boot.extraModprobeConfig = ''
    options brcmfmac feature_disable=0x282000
    options brcmfmac roamfoff=1
  '';

  #hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkForce true;
  #hardware.raspberry-pi."4".audio.enable = true;

  programs.neovim.withRuby = lib.mkForce false;
  programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;
  programs.neovim.enable = lib.mkForce false;

}
