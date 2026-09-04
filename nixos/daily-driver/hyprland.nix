{pkgs, config, lib, ...}:
{
  options.daily-driver.hyprland = lib.mkEnableOption "Enable Hyprland";
  config = lib.mkIf config.daily-driver.hyprland {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.unstable.hyprland;
      #portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
      #package = pkgs.hyprland_latest;
      #portalPackage = pkgs.hyprland_portal_latest;
    };

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      hyprpaper
      hyprpolkitagent
      unstable.hypridle
    ];

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "start-hyprland";
          user = "bestest";
        };
        default_session = initial_session;
      };
    };

    systemd.user.targets.hyprland-session = {
      enable = true;
      description = "Hyprland Session";
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      unitConfig = {
        PropagatesStopTo = "graphical-session.target";
      };
    };
  };
}
