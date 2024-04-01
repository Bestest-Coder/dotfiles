{pkgs, ...}:
{
  # everything generally involved with the desktop, or the desktop environment
  # i.e. window manager, task bar, audio systems, etc
  environment.systemPackages = with pkgs; [
    # window manager (and utils)
    xdg-desktop-portal-hyprland
    #xdg-desktop-portal-gtk
    polkit
    polkit_gnome
    xdg-utils
    swaylock
    fuzzel
    unstable.waybar
    dunst
    hyprpaper
    brightnessctl
    networkmanagerapplet
    # audio (and utils)
    wireplumber
    pavucontrol
    helvum
    easyeffects
  ];

  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = ["Terminus"]; })
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = pkgs.unstable.hyprland;
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    #style = "breeze";
  };
  
}
