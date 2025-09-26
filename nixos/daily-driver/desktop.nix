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
    libnotify
    hyprpaper
    brightnessctl
    networkmanagerapplet
    # audio (and utils)
    wireplumber
    pavucontrol
    unstable.helvum
    unstable.easyeffects
    libinput
    unstable.hypridle
    libsForQt5.qt5ct
    #libsForQt5.breeze-qt5
    #libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
  ];

  fonts.packages = with pkgs; [
    font-awesome
    liberation_ttf
    #(nerdfonts.override { fonts = ["Terminus"]; })
    nerd-fonts.terminess-ttf
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.unstable.hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    #package = pkgs.hyprland_latest;
    #portalPackage = pkgs.hyprland_portal_latest;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      #xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
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

  # stylix = {
  #   enable = true;
  #   # assumes that dotfiles is in home directory, references same image as hyprpaper
  #   #image = ../../../wallpaper.png;
  #   polarity = "dark";
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/isotope.yaml";
  # };
  #programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
    # style = {
    #   name = "gtk2";
    #   package = pkgs.libsForQt5.breeze-qt5;
    # };
  };
  # gtk = {
  #   enable = true;
  #   theme = {
  #     #name = "adw-gtk3-dark";
  #     #package = pkgs.awd-gtk3;
  #     name = "Breeze-Dark";
  #     package = pkgs.libsForQt5.breeze-gtk;
  #   };
  #   iconTheme = {
  #     name = "Breeze-Dark";
  #     package = pkgs.libsForQt5.breeze-icons;
  #   };
  #   gtk3 = {
  #     extraConfig.gtk-application-prefer-dark-theme = true;
  #   };
  # };
  
}
