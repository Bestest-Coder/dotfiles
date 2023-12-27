{pkgs,...}:
{
  # things that are required or effectively required for general use
  # i.e. terminal, web browser, file browser, cli utils
  environment.systemPackages = with pkgs; [
    firefox
    mpv
    unstable.discord
    kitty
    xfce.thunar
    gimp
    audacity
    curl
    ack
    #virt-manager
    playerctl
    flameshot # screenshot tool
    piper # mouse config
    bitwarden
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
