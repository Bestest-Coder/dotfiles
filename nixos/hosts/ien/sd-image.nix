{config, lib, pkgs, ...}:
{

  disabledModules = [
    "profiles/all-hardware.nix"
    "profiles/base.nix"
    ./hardware-configuration.nix
  ];

  boot.loader.generic-extlinux-compatible.enable = true;
  boot.supportedFilesystems.zfs = lib.mkForce false;

  #boot.consoleLogLevel = lib.mkDefault 7;

  users.users.root.initialPassword = "";

  console = {
    earlySetup = true;
    font = lib.mkForce null;
    packages = lib.mkForce [];
  };

  boot.kernelParams = [
    "8250.nr_uarts=1"
    "vc_mem.mem_base=0x3ec00000"
    "vc_mem.mem_size=0x20000000"
    "console=ttyS0,115200"
    "console=tty1"
    "plymouth.ignore-serial-consoles"
    "snd_bcm2835.enable_hdmi=1"
    "snd_bcm2835.enable_headphones=1"
    "psi=1"
    "iommu=force"
    "iomem=relaxed"
    "swiotlb=131072"
  ];

  hardware.raspberry-pi."4" = {
    xhci.enable = false;
    dwc2.enable = true;
    dwc2.dr_mode = "host";
    # overlays = {
    #   cpu-revision.enable = true;
    #   audremap.enable = true;
    #   vc4-kms-v3d.enable = true;
    #   cpi-disable-pcie.enable = true;
    #   cpi-disable-genet.enable = true;
    #   cpi-uconsole.enable = true;
    #   cpi-i2c1.enable = false;
    #   cpi-spi4.enable = false;
    #   cpi-bluetooth.enable = true;
    # };
  };

  hardware.deviceTree = {
    enable = true;
    filter = "bcm2711-rpi-cm4.dtb";
    overlays = (import ./dt-overlays.nix) ++ [
      {
        name = "vc4-kms-v3d-pi4,cma-384";
        dtboFile = "${config.boot.kernelPackages.kernel}/dtbs/overlays/vc4-kms-v3d-pi4.dtbo";
        filter = "bcm2711-rpi-cm4.dtb";
      }
      {
        name = "audremap,pins_12_13";
        dtboFile = "${config.boot.kernelPackages.kernel}/dtbs/overlays/audremap.dtbo";
        filter = "bcm2711-rpi-cm4.dtb";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
    iw
    gitMinimal
  ];

  # networking.wireless = {
  #   userControlled.enable = true;
  #   enable = true;
  # };
  networking.networkmanager.enable = true;

  image.baseName = "nixos-sd-uconsole-custom";
  sdImage = {
    compressImage = false;
    populateFirmwareCommands = let
      # configTxt = pkgs.writeText "config.txt" ''
      #   [pi3]
      #   kernel=u-boot-rpi3.bin
      #
      #   [pi4]
      #   kernel=u-boot-rpi4.bin
      #   enable_gic=1
      #   armstub=armstub8-gic.bin
      #
      #   # Otherwise the resolution will be weird in most cases, compared to
      #   # what the pi3 firmware does by default.
      #   disable_overscan=1
      #
      #   # Supported in newer board revisions
      #   arm_boost=1
      #
      #   [cm4]
      #   # Enable host mode on the 2711 built-in XHCI USB controller.
      #   # This line should be removed if the legacy DWC2 controller is required
      #   # (e.g. for USB device mode) or if USB support is not required.
      #   # otg_mode=1
      #   # ------------------------
      #   arm_boost=1
      #   max_framebuffers=2
      #   # dtoverlay=vc4-kms-v3d-pi4,cma-384
      #   # dtoverlay=uconsole,cm4
      #   # ------------------------
      #
      #   [all]
      #   # Boot in 64-bit mode.
      #   arm_64bit=1
      #
      #   # U-Boot needs this to work, regardless of whether UART is actually used or not.
      #   # Look in arch/arm/mach-bcm283x/Kconfig in the U-Boot tree to see if this is still
      #   # a requirement in the future.
      #   enable_uart=1
      #
      #   # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
      #   # when attempting to show low-voltage or overtemperature warnings.
      #   avoid_warnings=1
      #
      #   # ------------------------
      #   ignore_lcd=1
      #   disable_fw_kms_setup=1
      #   disable_audio_dither
      #   pwm_sample_bits=20
      #
      #   # setup headphone detect pin
      #   gpio=10=ip,np
      #
      #   dtoverlay=dwc2,dr_mode=host
      #   dtoverlay=audremap,pins_12_13
      #   dtparam=audio=on
      #   # dtparam=spi=on
      #   dtparam=ant2
      #   # ------------------------
      #'';
      configTxt = pkgs.writeText "config.txt" ''
        [pi4]
        kernel=u-boot-rpi4.bin
        enable_gic=1
        armstub=armstub8-gic.bin
        arm_boost=1

        [cm4]
        arm_boost=1
        max_framebuffers=2

        [all]
        arm_64bit=1
        enable_uart=1
        avoid_warnings=1
        gpio=10=ip,np
        gpio=11=op
        arm_boost=1

        over_voltage=6
        arm_freq=2000
        gpu_freq=750

        display_auto_detect=1
        ignore_lcd=1
        disable_fw_kms_setup=1
        disable_audio_dither=1
        pwm_sample_bits=20

        dtparam=audo=on
      '';
    in ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

      # Add the config
      cp ${configTxt} firmware/config.txt

      # Add pi4 specific files
      cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
      cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      mkdir -p ./files/boot/firmware
      mkdir -p ./files/etc/nixos
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
