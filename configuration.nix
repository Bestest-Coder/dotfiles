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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUXsMyXC9Ono4ErYoBRtiW5qEYNATBgsGhB4La1ViExtrSFNU1K5Cx3wcl7zLcNtUPxJFV++uRdLvybbb4cLFUxgTSU6I+CBm9deKq3xFCp6gEdHz1MBuC2VJJm8EVQt1s0wiCRDYMFJDcWeb+3a+wSd19LtQiVZhgySEGREUZ8Ay7DGp7Ta3rS7NMeXRGjXayJi/QULPr6c0ZswaW463jgTSWPNEhzHoosF1xML4CV6WdW8nwuI9UaO90GCgd2AxySeQ0P+Qyh2CXAquHp8Q+OJHV7uYmXNxQe+et8aDlMnTNInUyo8/LS5KCRnmd/rQg+ZRMQXq32rJE5JuRzuTkha1Tc38vNQBkSRvMawASHzpYdDwSHfZk7Yo61fUwaND8NnAhB7eIUGVdsuPlZdJnwJ4vKIn1xJr4+3dHgTZRZYV+PXzYoFlEOcFDh0voXJmqveRwLXD9WxvaJXJ8/AvrWQq/06fg+MzH8ujFoDMTY/j1wH2VqgoiRdopDnjD+RNI4XMw9IuhmJk48ky0tvTX2WFrFwCc7MJrTUF/RVq2MqRmbznkFRuCiS/DvkBKauxMliv3VPcJfTPXHjhotr8DV95nzBuGru/QmNkig4Sg28WStqaUMTFCkBZQaxWuKn/8ExvqIsxV1ZFywRXxmjSnkin2UUBDGJzMbjl/ZAgzzw== techlord18@gmail.com"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #neovim
    unixtools.xxd # adds xdd to neovim (not included by default)
    btop
    killall
    findutils
    findutils.locate
    pciutils
    file
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    package = pkgs.unstable.neovim-unwrapped;
    withRuby = false;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    shellAliases = {
      update-s = "sudo nixos-rebuild switch";
      update-b = "sudo nixos-rebuild boot";
      waybar-restart = "killall -9 .waybar-wrapped; waybar &!";
    };
    histSize = 10000;
    histFile = "$HOME/.histfile";
    promptInit = "PROMPT=\"%F{blue}┌%F{green}[%n]%F{magenta}@%F{yellow}[%M]
%F{blue}└─%F{white}(%F{red}%~%F{white}) %#%F{10}$SHLVL>%F{white} \"";
    shellInit = "export PATH=~/.npm-packages/bin:$PATH;
    export NODE_PATH=~/.npm-packages/lib/node_modules";
  };

  programs.direnv.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-30d";
  };
  
  nix.settings = {
    auto-optimise-store = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

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
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
