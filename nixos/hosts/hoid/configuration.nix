{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../daily-driver/daily-driver.nix
    ../../configuration.nix
  ];

  networking.hostName = "hoid";

  boot.loader.grub.device = "/dev/vda"; #change when get actual device
  boot.loader.grub.devices = ["/dev/vda"];
}
