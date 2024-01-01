{
  imports = [
    /etc/nixos/hardware-configuration
    ../../daily-driver/daily-driver.nix
  ];

  networking.hostName = "hoid";

  boot.loader.grub.device = "/dev/vda"; #change when get actual device
}
