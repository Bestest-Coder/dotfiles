{pkgs, ...}:
let
  discord_override = pkgs.discord.overrideAttrs (old: rec {
    version = "0.0.104";
    src = pkgs.fetchurl {
      url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      hash = "sha256-4w8C9YHRNTgkUBzqkW1IywKtRHvtlkihjo3/shAgPac=";
    };
  });
in
{
  # things that are required or effectively required for (my) general use
  # i.e. terminal, web browser, file browser, cli utils, configuration
  environment.systemPackages = with pkgs; [
    mpv
    discord
    #discord_override
    #unstable.kitty
    curl
    ack
    #virt-manager
    playerctl
    grim
    slurp
    wl-clipboard
    bitwarden-desktop
    powertop
    ripgrep
    wev
    p7zip
    dig
    pv
    unstable.wineWowPackages.unstable
    winetricks
    wireguard-tools
    xfce.xfce4-icon-theme
    fzf
    qdirstat
    wev
    feh
  ];

  programs.firefox.enable = true;

  services = {
    tailscale.enable = true;
    mullvad-vpn.enable = true;
    resolved.enable = true;
    ratbagd.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;
  home-manager.users.bestest = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
