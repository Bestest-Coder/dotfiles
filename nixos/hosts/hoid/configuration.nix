{pkgs, config, ...}: 
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../../daily-driver/daily-driver.nix
    ../../../configuration.nix
  ];

  networking.hostName = "hoid";

  environment.systemPackages = with pkgs; [
    (callPackage ../../packages/run-prime {})
    nvtop-amd
    glxinfo
    vulkan-tools
    yt-dlp
    jstest-gtk
    usbutils
  ];

  boot.initrd.kernelModules = ["amdgpu"];

  #boot.kernelPackages = pkgs.linuxPackages_6_7;

  boot.loader.systemd-boot.enable = true;
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/nvme0n1p1"; # change when get actual device
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #boot.loader.grub.devices = ["/dev/nvme0n1p1"];

  # framework stuff
  services = {
    fwupd.enable = true;
    fprintd.enable = true;
    #tlp.enable = true;
    power-profiles-daemon.enable = true;
    blueman.enable = true;
  };

  hardware.bluetooth.enable = true;

  #hardware.opengl = {
  #  extraPackages = with pkgs; [
  #    amdvlk
  #  ];
  #  extraPackages32 = with pkgs; [
  #    driversi686Linux.amdvlk
  #  ];
  #};

  security.pam.services.swaylock.fprintAuth = true;

    nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraLibraries ? pkgs': [], ... }: {
        extraLibraries = pkgs': (extraLibraries pkgs') ++ ( [
          pkgs'.gperftools
        ]);
      });
    })
  ];

}
