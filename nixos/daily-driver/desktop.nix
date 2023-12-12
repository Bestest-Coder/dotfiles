{pkgs, ...}:
{
  # everything generally involved with the desktop, or the desktop environment
  # i.e. window manager, task bar, audio systems, etc
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    polkit
    polkit_gnome
    xdg-utils
    pipewire
    swaylock
    fuzzel
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["Terminus"]; })
  ];
    

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.users.bestest = {
    xdg.configFile."hypr".source = ../../hyprland;
    xdg.configFile."fuzzel".source = ../../fuzzel;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
  security.polkit.enable = true;

}
