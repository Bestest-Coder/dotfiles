{config, pkgs, ...}:
{
  # everything that is purely for recreation
  # i.e. games, music, recording, etc
  environment.systemPackages = with pkgs; [
    spotify
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
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
    openttd
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
  hardware.opengl.driSupport32Bit = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
