{pkgs, nixpkgs, config, lib, ... }:
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible = {
      enable = true;
    };
  };

  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;

  boot.kernelParams = ["console=tty0" "console=ttyS0,115200n8"];

  sdImage = {
    # raspi firmware. for riscv-qemu this is empty
    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1

        [pi0]
        kernel=u-boot-rpi0.bin

        [pi1]
        kernel=u-boot-rpi1.bin
      '';
    in ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
      cp ${configTxt} firmware/config.txt
      '';
      #cp ${pkgs.ubootRaspberryPiZero}/u-boot.bin firmware/u-boot-rpi0.bin
      #cp ${pkgs.ubootRaspberryPi}/u-boot.bin firmware/u-boot-rpi1.bin
    #'';

    # common across raspi and riscv-qemu
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
