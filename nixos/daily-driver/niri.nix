{pkgs, config, lib, ...}:
{
  options.daily-driver.niri = lib.mkEnableOption "Enable Niri";
  # everything needed for specifically Hyprland
  config = lib.mkIf config.daily-driver.niri {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      swaybg
      swayidle
      xwayland-satellite
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.niri.package}/bin/niri-session";
          user = "bestest";
        };
      };
    };

    systemd.user.services.niri.enableDefaultPath = false;
  };
}
