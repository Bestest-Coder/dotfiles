{pkgs, lib, config, ...}: 
let
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
  # overridden_sm64coopdx = pkgs.unstable.sm64coopdx.overrideAttrs (old: rec {
  #   version = "1.3";
  #   src = pkgs.fetchFromGitHub {
  #     owner  = "coop-deluxe";
  #     repo   = "sm64coopdx";
  #     rev    = "v${version}";
  #     sha256 = "sha256-ssbvNnBBxahzJRIX5Vhze+Nfh3ADoy+NrUIF2RZHye8=";
  #   };
  #   buildInputs = old.buildInputs ++ [ pkgs.unstable.libGL ];
  # });
  unstableCallPackage = pkgs.lib.callPackageWith (pkgs.unstable);
  stableCallPackage = pkgs.lib.callPackageWith (pkgs.stable);
in {
  imports = [
    ./hardware-configuration.nix
    #../../daily-driver/daily-driver.nix { withHyprland = true; withSteam = true; withOBS = true;}
    ../../daily-driver/daily-driver.nix
    ../../../configuration.nix
    ./riftcv1.nix
  ];

  daily-driver.hyprland = true;
  daily-driver.steam = true;
  daily-driver.obs = true;

  networking.hostName = "hoid";

  environment.systemPackages = with pkgs; [
    # self built
    (callPackage ../../packages/run-prime {})
    (callPackage ../../packages/bestestoolscript {})
    (callPackage ../../packages/bestestscreenshot {})
    #(callPackage ../../packages/citymania {})
    (callPackage ../../packages/twad {})
    #(unstableCallPackage ../../packages/nyxt-latest {sbcl = pkgs.stable.sbcl; nodejs = nodejs_20; electron = electron_32;})
    #(stableCallPackage ../../packages/nyxt-latest {})
    #(callPackage ../../packages/VPKEdit {})
    #(callPackage ../../packages/smokin-guns {})
    (callPackage ../../packages/ironwail {})

    # misc tools
    nvtopPackages.amd
    mesa-demos
    vulkan-tools
    usbutils
    dmidecode
    yt-dlp
    alsa-oss
    evtest
    #chirp
    xhost
    imagemagick
    unstable.via
    ffmpeg
    eza
    wireguard-tools
    extest

    nodejs_22 #need for neovim coc :woeisme:
    nixd

    # graphical tools/utilities
    #(bitwarden-desktop.override { electron_39 = pkgs.electron_39-bin; })
    unstable.piper
    ungoogled-chromium
    jstest-gtk
    qdirstat

    # games
    nethack
    gzdoom
    #zandronum
    crispy-doom
    #prboom-plus
    unstable.ringracers
    #unstable.srb2kart
    #overridden_sm64coopdx
    unstable.sm64coopdx
    #lumafly
    ioquake3
    azahar
    archipelago
    #poptracker
    unstable.prismlauncher
    pcsx2
    stable.rpcs3
    openttd
    #lutris
    r2modman
    unstable.mangohud
    itch
    (retroarch.withCores (cores: with cores; [
      snes9x
      beetle-psx
      beetle-psx-hw
      mesen
    ]))

    # music and media
    tidal-hifi
    jellyfin-desktop
    #audacious
    #strawberry
    calibre

    #unstable.mumble
    #qutebrowser
    #nyxt
    zoom-us
    #guvcview
    wezterm
    pkgsRocm.blender
    #gparted
  ];

  services.udev = {
    packages = with pkgs; [ 
      unstable.via
    ];
    extraRules = ''
      ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };

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

  #boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  # needed to revert because AMDGPU sometimes crashes after suspend (close/open lid)
  #boot.kernelPackages = pkgs.unstable.linuxPackages_6_12;
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/nvme0n1p1"; # change when get actual device
  boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  #boot.loader.grub.devices = ["/dev/nvme0n1p1"];

  # framework stuff
  services = {
    fwupd.enable = true;
    fprintd.enable = true;
    #tlp.enable = true;
    power-profiles-daemon.enable = true;
    blueman.enable = true;
    lact.enable = true;
  };


  hardware.keyboard.qmk.enable = true;

  hardware.bluetooth.enable = true;

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl
      rocmPackages.clr.icd
    ];
  };


  security.pam.services.swaylock.fprintAuth = true;

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];

  ## suspend to disk stuff
  boot = {
    kernelParams = ["resume_offset=305248256"];
    resumeDevice = "/dev/disk/by-uuid/6efcc105-ca1a-452e-a84c-3c18b17226b8";
  };
  powerManagement.enable = true;
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };

  programs.nix-ld = {
    enable = true;
    ## TODO: make apdoom package to remove this
    libraries = with pkgs; [
      SDL2_mixer
      libsamplerate
      fluidsynth
      SDL2
    ];
  };

  networking.firewall = {
    enable = lib.mkForce false;
    allowedTCPPorts = [ 53 67 ];
    allowedUDPPorts = [ 53 67 ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # cache for cross compiling ien
  #nix.settings.substituters = ["https://cache-nix.project2.xyz/uconsole"];
  #nix.settings.trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
  #nix.settings.trusted-public-keys = ["uconsole:vvqOLjqEwTJBUqv1xdndD1YHcdlMc/AnfAz4V9Hdxyk="];

  # nnn zsh config
  programs.zsh.shellInit = lib.mkAfter ''
    n ()
    {
      # Block nesting of nnn in subshells
      [ "''${NNNLVL:-0}" -eq 0 ] || {
          echo "nnn is already running"
          return
      }

      # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
      # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
      # see. To cd on quit only on ^G, remove the 'export' and make sure not to
      # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
      #      NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
      export NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

      # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
      # stty start undef
      # stty stop undef
      # stty lwrap undef
      # stty lnext undef

      # The command builtin allows one to alias nnn to n, if desired, without
      # making an infinitely recursive alias
      command nnn -P p $@

      [ ! -f "$NNN_TMPFILE" ] || {
          . "$NNN_TMPFILE"
          rm -f -- "$NNN_TMPFILE" > /dev/null
      }
    }
    NNN_PLUG_SHELL='x:!chmod +x "$nnn";l:!git log;g:-!git diff'
    NNN_PLUG_MANAGEMENT='u:getplugs'
    NNN_PLUG_INTERFACE='p:preview-tui'
    NNN_PLUG="$NNN_PLUG_SHELL;$NNN_PLUG_MANAGEMENT;$NNN_PLUG_INTERFACE"
    export NNN_PLUG

    export NNN_FIFO=/tmp/nnn.fifo
    '';

    boot.kernel.sysctl."kernel.sysrq" = 1;

  services.timesyncd.enable = true;

  users.users.nixremote = {
    isNormalUser = true;
    createHome = true;
    group = "nixremote";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo8mKYDrxFvOPEmlY6velYUu+O6fvDhdkx8rTS/RJBA root@ien"
    ];
  };

  users.groups.nixremote = {};
  nix.settings.trusted-users = [ "nixremote" ];

  # security.tpm2 = {
  #   enable = true;
  #   pkcs11.enable = true;
  #   tctiEnvironment.enable = true;
  # };
  # users.users.bestest.extraGroups = [ "tss" ];


  virtualisation.waydroid.enable = true;

  programs.steam.extraPackages = with pkgs; [ hidapi ];
}

