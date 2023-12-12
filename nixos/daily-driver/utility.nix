{pkgs,...}:
{
  # things that are required or effectively required for general use
  # i.e. terminal, web browser, file browser, cli utils
  environment.systemPackages = with pkgs; [
    firefox
    mpv
    discord
    kitty
    xfce.thunar
    gimp
    audacity
    curl
    ack
  ];

  home-manager.users.bestest = {
    xdg.configFile."kitty".source = ../../kitty;
  };
}
