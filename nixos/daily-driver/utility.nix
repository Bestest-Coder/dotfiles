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
    curl
    ack
    playerctl
    grim
    slurp
    wl-clipboard
    powertop
    ripgrep
    wev
    p7zip
    dig
    wine
    winetricks
    xfce4-icon-theme
    fzf
    wev
    feh

    #dolphin stuff
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kservice
    kdePackages.ark
    kdePackages.kio
    kdePackages.kdf
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.kdegraphics-thumbnailers
    unrar
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

  xdg.mime.enable = true;
  xdg.menus.enable = true;
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

}
