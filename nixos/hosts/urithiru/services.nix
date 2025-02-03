{pkgs, lib, config, ...}:
{
  imports = [
    ./frp-token.nix
  ];
  services = {
    murmur = {
      enable = true;
      package = pkgs.unstable.murmur;
      openFirewall = true;
      environmentFile = config.age.secrets.murmur-env.path;
      welcometext = "Welcome to Total Drama Murmur";
      password = "$MURMUR_PASSWORD"; # will get replaced from env file
      users = 10;
      port = 64738; # default value, for reminder
    };
    frp = {
      enable = true;
      role = "client";
      settings = {
        #includes = [config.age.secrets.frp-toml.path];
        serverAddr = "138.197.62.203";
        serverPort = 7000;
        auth.method = "token";
        proxies = [
          {
            name = "mumble-tcp";
            type = "tcp";
            localIP = "127.0.0.1";
            localPort = 64738;
            remotePort = 64738;
          }
          {
            name = "mumble-udp";
            type = "udp";
            localIP = "127.0.0.1";
            localPort = 64738;
            remotePort = 64738;
          }
        ];
      };
    };
  };
  systemd.services.frp.serviceConfig.Group = "frp";
}
