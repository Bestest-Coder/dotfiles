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
    virt-manager
  ];

  home-manager.users.bestest = {
    xdg.configFile."kitty".recursive = true;
    xdg.configFile."kitty".source = ../../kitty;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  home-manager.users.bestest = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
