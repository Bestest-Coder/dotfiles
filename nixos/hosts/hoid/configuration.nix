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
    (callPackage ../../packages/bestestoolscript {})
    (callPackage ../../packages/bestestscreenshot {})
    nvtopPackages.amd
    glxinfo
    vulkan-tools
    yt-dlp
    jstest-gtk
    usbutils
    ungoogled-chromium
    alsa-oss
    dmidecode
    #unstable.fontmatrix
    #teams
  ];

  environment.etc = {
    # makes palm reject/disable touchpad while typing work
    "libinput/local-overrides.quirks" = {
      text = ''
        [Framework Laptop 16 Keyboard Module]
        MatchName=Framework Laptop 16 Keyboard Module*
        MatchUdevType=keyboard
        MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
        AttrKeyboardIntegration=internal
      '';
    };
  };

  boot.initrd.kernelModules = ["amdgpu"];

  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

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

  programs.steam.package = pkgs.steam.override ({ extraLibraries ? pkgs': [], ... }: {
    extraLibraries = pkgs': (extraLibraries pkgs') ++ ( [
      pkgs'.gperftools
    ]);
  });
}
