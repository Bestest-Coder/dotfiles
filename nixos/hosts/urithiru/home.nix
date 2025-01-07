{pkgs, ...}:
{
  home.stateVersion = "23.11";
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source =  ../../neovim;
}
