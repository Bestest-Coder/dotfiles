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

}
