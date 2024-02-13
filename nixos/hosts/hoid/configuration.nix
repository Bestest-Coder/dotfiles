{
  imports = [
    ./hardware-configuration.nix
    ../../daily-driver/daily-driver.nix
    ../../../configuration.nix
  ];

  networking.hostName = "hoid";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda"; # change when get actual device
  boot.loader.grub.useOSProber = true;
  #boot.loader.grub.devices = ["/dev/vda"];

  # framework stuff
  services = {
    fwupd.enable = true;
    fprintd.enable = true;
  };
}
