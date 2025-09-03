{nixpkgs, pkgs, lib, ...}:
let
  inherit (import ./lib.nix {inherit nixpkgs;}) callPackagesCrossAarch64;
in
{
  imports = [
    ../../../configuration.nix
    ./hardware-configuration.nix
    ./kernel.nix
  ];


  networking.hostName = "ien";

  programs.labwc.enable = true;
  #programs.waybar.enable = true;
  #programs.gamescope.enable = true;

  #programs.steam.enable = true;
  #hardware.graphics.enable32Bit = false;

  environment.systemPackages = with pkgs; [
    #(callPackage ../../packages/twad {})
    kitty
    foot
    firefox
    libqalculate
    qalculate-gtk
    crispy-doom
    fuzzel
    wlr-randr
    # (retroarch.withCores (cores: with cores; [
    #
    # ]))
    (callPackagesCrossAarch64 (retroarch.withCores (cores: with cores; [
      #snes9x
      #beetle-psx
      #beetle-psx-hw
      fbneo
    ])) {})
  ];

  #networking.networkmanager.enable = lib.mkForce false;
  system.stateVersion = lib.mkForce "25.05";

  services.tailscale = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
    liberation_ttf
    #(nerdfonts.override { fonts = ["Terminus"]; })
    nerd-fonts.terminess-ttf
  ];

  nix.buildMachines = [{
    hostName = "builder"; # actually hoid, but have alias in sshd
    systems = ["x86_64-linux" "aarch64-linux"];
    protocol = "ssh-ng";
    maxJobs = 1;
    speedFactor = 2;
    supportedFeatures = ["big-parallel" "kvm"];
  }];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  boot.extraModprobeConfig = ''
    options brcmfmac feature_disable=0x282000
    options brcmfmac roamfoff=1
  '';

  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkForce true;
  #hardware.raspberry-pi."4".audio.enable = true;

  programs.neovim.withRuby = lib.mkForce false;
  programs.neovim.package = lib.mkForce pkgs.neovim-unwrapped;
  #programs.neovim.enable = lib.mkForce false;

  nix.settings = {
    substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-public-keys = ["uconsole:vvqOLjqEwTJBUqv1xdndD1YHcdlMc/AnfAz4V9Hdxyk="];
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "labwc";
        user = "bestest";
      };
      default_session = initial_session;
    };
  };

  # ensuring this is here from sd-image.nix, I think might be necessary for on-device rebuilds?
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
      overlays = [
        {
          name = "cpu-revision";
          filter = "bcm2711-rpi-*.dtb";
          dtsFile = ./dt-source/cpu-revision.dts;
        }
        {
          name = "audremap";
          filter = "bcm2711-rpi-*.dtb";
          dtsFile = ./dt-source/audremap.dts;
        }
        {
          name = "vc4-kms-v3d";
          filter = "bcm2711-rpi-*.dtb";
          dtsFile = ./dt-source/vc4-kms-v3d.dts;
        }
        {
          name = "cpi-disable-pcie";
          filter = "bcm2711-rpi-cm4.dtb";
          dtsFile = ./dt-source/cpi-disable-pcie.dts;
        }
        {
          name = "cpi-disable-genet";
          filter = "bcm2711-rpi-cm4.dtb";
          dtsFile = ./dt-source/cpi-disable-genet.dts;
        }
        {
          name = "cpi-uconsole";
          filter = "bcm2711-rpi-cm4.dtb";
          dtsFile = ./dt-source/cpi-uconsole.dts;
        }
        # {
        #   name = "cpi-i2c1";
        #   filter = "bcm2711-rpi-cm4.dtb";
        #   dtsFile = ./dt-source/cpi-i2c1.dts;
        # }
        # {
        #   name = "cpi-spi4";
        #   filter = "bcm2711-rpi-cm4.dtb";
        #   dtsFile = ./dt-source/cpi-spi4.dts;
        # }
        {
          name = "cpi-bluetooth";
          filter = "bcm2711-rpi-cm4.dtb";
          dtsFile = ./dt-source/cpi-bluetooth.dts;
        }
    ];
  };
}
