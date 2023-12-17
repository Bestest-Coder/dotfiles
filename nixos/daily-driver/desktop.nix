{pkgs, ...}:
{
  # everything generally involved with the desktop, or the desktop environment
  # i.e. window manager, task bar, audio systems, etc
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    #xdg-desktop-portal-gtk
    polkit
    polkit_gnome
    xdg-utils
    pipewire
    swaylock
    fuzzel
    waybar
    dunst
    hyprpaper
    wireplumber
    pavucontrol
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
    xdg.configFile."waybar".source = ../../waybar;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      #xdg-desktop-portal-gtk
    ];
  };
  security.polkit.enable = true;

  security.pam.services.swaylock = {};

}
