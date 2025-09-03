{pkgs, config, ...}:
{
  home.stateVersion = "25.05";
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source =  ../../../neovim;

  xdg.configFile."labwc".recursive = true;
  xdg.configFile."labwc".source =  ../../../labwc;

}
