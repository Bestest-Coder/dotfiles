{pkgs, ...}:
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

  #boot.loader.systemd-boot.enable = true;
}
