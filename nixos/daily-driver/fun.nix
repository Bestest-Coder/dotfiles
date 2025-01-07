{config, pkgs, ...}:
{
  # everything that is purely for recreation
  # i.e. games (and associated programs), music, recording, etc
  environment.systemPackages = with pkgs; [
    spotify
    (unstable.wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        input-overlay
        obs-scale-to-sound
      ];
    })
    protonup-qt
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    unstable.prismlauncher
    (retroarch.override {
      cores = with libretro; [
        snes9x
        beetle-psx
        beetle-psx-hw
      ];
    })
    #openttd - replaced with citymania from custom package at packages/citymania
    lutris
    r2modman
    ani-cli
    unstable.calibre
    unstable.mangohud
    itch
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
