{pkgs, lib, ...}:
{
  imports = [
    ../../../configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "ien";

  programs.labwc.enable = true;
  #programs.waybar.enable = true;
  #programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    #(callPackage ../../packages/twad {})
    #kitty
    foot
    #firefox
    libqalculate
    qalculate-gtk
    crispy-doom
    fuzzel
  ];

  networking.networkmanager.enable = lib.mkForce false;
  system.stateVersion = lib.mkForce "25.05";

  #boot.loader.systemd-boot.enable = true;

  services.tailscale = {
    #enable = true;
  };

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

  services.avahi.enable = false;
  fonts.fontconfig.enable = false;

  programs.systemtap.enable = lib.mkForce false;

  programs.direnv.enable = lib.mkForce false;

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
}
