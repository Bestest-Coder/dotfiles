{pkgs,...}:
{
  # things that are required or effectively required for (my) general use
  # i.e. terminal, web browser, file browser, cli utils, configuration
  environment.systemPackages = with pkgs; [
    firefox
    mpv
    unstable.discord
    kitty
    curl
    ack
    #virt-manager
    playerctl
    flameshot # screenshot tool
    piper # mouse config
    bitwarden
    powertop
    ripgrep
    wev
    p7zip
    libsForQt5.dolphin
    libsForQt5.qt5ct
  ];

  services = {
    tailscale.enable = true;
    mullvad-vpn.enable = true;
    mullvad-vpn.package = pkgs.unstable.mullvad-vpn;
    resolved.enable = true;
    ratbagd.enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  #virtualisation.libvirtd.enable = true;
  #programs.dconf.enable = true;
  #home-manager.users.bestest = {
  #  dconf.settings = {
  #    "org/virt-manager/virt-manager/connections" = {
  #      autoconnect = ["qemu:///system"];
  #      uris = ["qemu:///system"];
  #    };
  #  };
  #};
}
