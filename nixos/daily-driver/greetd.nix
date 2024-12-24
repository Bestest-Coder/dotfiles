{ pkgs, ...}:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "bestest";
      };
      default_session = initial_session;
    };
  };
        
}
