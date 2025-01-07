{pkgs, config, ...}:
let

in {
  import = [
    ./docker-compose.nix
  ];

  environment.systemPackages = with pkgs; [

  ];

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker.enableNvidia = true; # deprecated but might still be needed

  services = {
    tailscale.enable = true;
    resolved.enable = true;
  };

  networking = {
    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.186";
      prefixLength = 24;
    }];
    defaultGateway = {
      address = "192.168.1.186";
      interface = "eno1";
    };
  };

  fileSystems."/home/bestest/mediaserver/data" = {
    device = "/dev/disk/by-uuid/4d99b272-c510-4daf-a0cb-df3f6fdff1e2";
    fsType = "ext4";
    options = [
      "nofail"
    ];
  };
}
