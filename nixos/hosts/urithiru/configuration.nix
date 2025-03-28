{pkgs, config, ...}:
let

in {
  imports = [
    ./podman-compose.nix
    ../../../configuration.nix
    ./hardware-configuration.nix
    ./services.nix
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
  ];

  networking.hostName = "urithiru";

  hardware.nvidia-container-toolkit.enable = true;
  #virtualisation.docker.enableNvidia = true; # deprecated but might still be needed
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  services = {
    tailscale.enable = true;
    # resolved.enable = true;
  };

  # networking = {
  #   interfaces.eno1.ipv4.addresses = [{
  #     address = "192.168.1.186";
  #     prefixLength = 24;
  #   }];
  #   defaultGateway = {
  #     address = "192.168.1.186";
  #     interface = "eno1";
  #   };
  # };

  fileSystems."/home/bestest/mediaserver/data" = {
    device = "/dev/disk/by-uuid/4d99b272-c510-4daf-a0cb-df3f6fdff1e2";
    fsType = "ext4";
    options = [
      "nofail"
    ];
  };
  boot.loader.systemd-boot.enable = true;

  # secrets
  age.secrets = {
    cloudflare-env.file = ../../../secrets/cloudflare-env.age;
    curseforge-env.file = ../../../secrets/curseforge-env.age;
    murmur-env.file     = ../../../secrets/murmur-env.age;
    frp-toml.file       = ../../../secrets/frp-toml.age;
    frp-toml.group = "frp";
    frp-toml.mode = "770";
  };

  #users.groups.frp = {};

  # god I hope this doesn't screw things up, sometimes just doesn't start
  systemd.services.NetworkManager-wait-online.enable = false;
}
