{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    mpv
    discord
    kitty
    xdg-desktop-portal-hyprland
    polkit
    polkit_gnome
    xdg-utils
  ];
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  programs.hyprland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
  security.polkit.enable = true;
}
