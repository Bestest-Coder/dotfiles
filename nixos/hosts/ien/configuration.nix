{pkgs, ...}:
{
  imports = [
    ../../../configuration.nix
    ../../helpers.nix
  ];

  networking.hostName = "ien";

  environment.systemPackages = with pkgs; [
    networkmanager
    tmux
    addCompileFlags glslang ["-latomic"]
  ];
}
