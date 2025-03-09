{pkgs, lib, ...}:
{
  imports = [
    ../../../configuration.nix
  ];

  networking.hostName = "ien";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
  ];

  networking.networkmanager.enable = lib.mkForce false;
  system.stateVersion = lib.mkForce "25.05";

  #boot.loader.systemd-boot.enable = true;
}
