{pkgs, lib, config, ...}:
{
  services = {
    frp = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "138.197.62.203";
        serverPort = 7000;
        auth.method = "token";
        auth.token = config.age.secrets.frp-toml.path;
        proxies = [
          {
            name = "hytale-udp";
            type = "udp";
            localIP = "127.0.0.1";
            localPort = "";
            remotePort = "52102";
          }
        ];
      };
    };
  };
}
