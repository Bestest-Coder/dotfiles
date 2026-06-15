{pkgs, config, lib, ...}:
{
  options.daily-driver.steam = lib.mkEnableOption "Enable Steam";
  config = lib.mkIf config.daily-driver.steam {
    # everything needed for a working steam installation
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
