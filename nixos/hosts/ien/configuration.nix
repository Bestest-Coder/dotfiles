{
  imports = [
    ../../../configuration.nix
  ];

  networking.hostName = "ien";

  environment.systemPackages = with pkgs; [
    networkmanager
    tmux
  ]
}
