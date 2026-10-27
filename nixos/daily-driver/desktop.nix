{pkgs, ...}:
{
  # things I use across any desktop/window manager
  # i.e. preferred terminal, bars, file manager, etc along with a few convenience softwares
  environment.systemPackages = with pkgs; [
    # utilies/services
    polkit
    polkit_gnome
    xdg-utils
    brightnessctl
    libnotify
    libinput
    libsForQt5.qt5ct
    #libsForQt5.breeze-icons
    # desktop utilities
    swaylock
    fuzzel
    unstable.waybar
    dunst
    networkmanagerapplet
    # audio (and utils)
    wireplumber
    pavucontrol
    #unstable.helvum
    crosspipe
    unstable.easyeffects
    qt6.qtwayland
    qt5.qtwayland
  ];

  fonts.packages = with pkgs; [
    font-awesome
    liberation_ttf
    #(nerdfonts.override { fonts = ["Terminus"]; })
    nerd-fonts.terminess-ttf
    nerd-fonts.roboto-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
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

  #programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  
}
