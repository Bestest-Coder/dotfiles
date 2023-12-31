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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      #xdg-desktop-portal-gtk
    ];
  };
  security.polkit.enable = true;

  security.pam.services.swaylock = {};

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
