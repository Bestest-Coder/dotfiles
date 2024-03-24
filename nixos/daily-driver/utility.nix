{pkgs,...}:
{
  # things that are required or effectively required for (my) general use
  # i.e. terminal, web browser, file browser, cli utils, configuration
  environment.systemPackages = with pkgs; [
    firefox
    mpv
    unstable.discord
    kitty
    xfce.thunar
    curl
    ack
    #virt-manager
    playerctl
    flameshot # screenshot tool
    piper # mouse config
    bitwarden
    powertop
    ripgrep
  ];

  services.tailscale.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.unstable.mullvad-vpn;
  services.resolved.enable = true;

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
