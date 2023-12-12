{pkgs, ...}:
{
  # everything that is purely for recreation
  # i.e. games
  environment.systemPackages = with pkgs; [
    steam
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;
}
