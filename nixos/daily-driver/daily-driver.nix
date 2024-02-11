{pkgs, ...}:
{
  # this is meant to have all the basics of a general use (for me) system
  imports = [
    ./greetd.nix
    ./productivity.nix
    ./utility.nix
    ./fun.nix
    ./desktop.nix
  ];

  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
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
      nssmdns = true;
      openFirewall = true;
    };
  };
}
