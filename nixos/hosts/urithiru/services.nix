{pkgs, lib, config, ...}:
{
  services = {
    murmur = {
      enable = false;
      package = pkgs.unstable.murmur;
      openFirewall = true;
      environmentFile = config.age.secrets.murmur-env.path;
      welcometext = "Welcome to Total Drama Murmur";
      password = "$MURMUR_PASSWORD"; # will get replaced from env file
      users = 10;
      port = 64738; # default value, for reminder
    };
  };
}
