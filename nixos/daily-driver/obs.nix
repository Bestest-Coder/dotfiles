{pkgs, config, lib, ...}:
{
  options.daily-driver.obs = lib.mkEnableOption "Enable OBS";
  config = lib.mkIf config.daily-driver.obs {
    # everything needed for a working OBS installation, with some extras
    environment.systemPackages = with pkgs; [
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
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };
}
