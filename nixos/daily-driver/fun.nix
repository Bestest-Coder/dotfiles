{pkgs, ...}:
{
  # everything that is purely for recreation
  # i.e. games
  environment.systemPackages = with pkgs; [
    steam
    spotify
    obs
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
