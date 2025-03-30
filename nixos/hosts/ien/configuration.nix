{pkgs, lib, ...}:
{
  imports = [
    ../../../configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ien";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    (callPackage ../../packages/twad {})
    kitty
    firefox
    libqalculate
    qalculate-gtk
    crispy-doom
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

  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkForce true;
  #hardware.raspberry-pi."4".audio.enable = true;
}
