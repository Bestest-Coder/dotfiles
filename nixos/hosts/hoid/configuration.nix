{pkgs, config, ...}: 
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
  overridden_piper = pkgs.piper.overrideAttrs (old: rec {
    version = "0.8";
    src = pkgs.fetchFromGitHub {
      owner  = "libratbag";
      repo   = "piper";
      rev    =  version;
      sha256 = "sha256-j58fL6jJAzeagy5/1FmygUhdBm+PAlIkw22Rl/fLff4=";
    };
    mesonFlags = [
      "-Druntime-dependency-checks=false"
    ];
  });
  overridden_ratbag = pkgs.libratbag.overrideAttrs (old: rec {
    version = "0.18";
    src = pkgs.fetchFromGitHub {
      owner  = "libratbag";
      repo   = "libratbag";
      rev    = "v${version}";
      sha256 = "sha256-dAWKDF5hegvKhUZ4JW2J/P9uSs4xNrZLNinhAff6NSc=";
    };
  });
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
    #(callPackage ../../packages/citymania {})
    (callPackage ../../packages/twad {})
    (callPackage ../../packages/sm64coopdx {})
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
    nethack
    gzdoom
    #zandronum
    #crispy-doom
    #prboom-plus
    unstable.ringracers
    unstable.via
    overridden_piper
    #unstable.piper
    evtest
    chirp
  ];

  services.ratbagd.package = overridden_ratbag;

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
  #boot.kernelPackages = pkgs.unstable.linuxPackages_6_10;

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

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.unstable.via ];

  hardware.bluetooth.enable = true;

  #hardware.opengl = {
  #  enable = true;
  #  driSupport32Bit = true;
    #package = pkgs.unstable.mesa.drivers;
    #package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;
  #};

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    #package = pkgs.lib.mkForce pkgs.unstable.mesa.drivers;
    #package32 = pkgs.lib.mkForce pkgs.unstable.pkgsi686Linux.mesa.drivers;
  };

  #system.replaceRuntimeDependencies = [
  #  ({original = pkgs.mesa; replacement = pkgs.unstable.mesa;})
  #  ({original = pkgs.mesa.drivers; replacement = pkgs.unstable.mesa.drivers;})

  security.pam.services.swaylock.fprintAuth = true;

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];
}
