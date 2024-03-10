# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, lib, pkgs, self, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      #/etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.devices = ["/dev/vda"];
  #boot.loader.grub.useOSProber = true;

  #networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bestest = {
    isNormalUser = true;
    description = "Bestest User";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #neovim
    unixtools.xxd # adds xdd to neovim (not included by default)
    git
    btop
    killall
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      update-s = "sudo nixos-rebuild switch";
      update-b = "sudo nixos-rebuild boot";
    };
    histSize = 10000;
    histFile = "$HOME/.histfile";
    promptInit = "PROMPT=\"%F{blue}┌%F{green}[%n]%F{magenta}@%F{yellow}[%M]
%F{blue}└─%F{white}(%F{red}%~%F{white}) %#%F{10}>%F{white} \"";
  };

  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-30d";
  };
  
  nix.settings.auto-optimise-store = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
