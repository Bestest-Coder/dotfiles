{
  self,
  pkgs,
  lib,
  # withHyprland ? false,
  # withNiri ? false,
  # withSteam ? false,
  # withOBS ? false,
  # withVirt ? false,
  ...
}:
{
  # meant to be all the bare minimums of what I need to use a system fairly regularly
  # everything beyond basics goes in system specific configs (see ../hosts)
  # some files also provide accompanying packages for common software (WMs, Steam, etc)
  imports = [
    ./productivity.nix
    ./utility.nix
    ./desktop.nix
    ./niri.nix
    ./hyprland.nix
    ./obs.nix
    ./steam.nix
  ]
  # ++ lib.optional withHyprland ./hyprland.nix
  # ++ lib.optional withNiri ./niri.nix
  # ++ lib.optional withSteam ./steam.nix
  # ++ lib.optional withOBS ./obs.nix
  # ++ lib.optional withVirt ./virt.nix
  ; # this feels so weird


  environment.systemPackages = with pkgs; [
    nix-tree
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "-L"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  services = {
    flatpak.enable = true;
    printing = {
      enable = true;
      #drivers = [];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    libinput = {
      touchpad.accelProfile = "flat";
      touchpad.disableWhileTyping = true;
    };
  };
}
