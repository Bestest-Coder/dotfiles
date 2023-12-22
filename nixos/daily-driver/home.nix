{pkgs, ...}:
{
  home-manager.users.bestest = {
    home.stateVersion = "23.11";
    xdg.configFile."nvim".recursive = true;
    xdg.configFile."nvim".source = ../neovim;

    programs.zsh = {
      enable = true;
      shellAliases = {
        update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
      };
      initExtra = "PROMPT=\"%F{blue}┌%F{green}[%n]%F{magenta}@%F{yellow}[%M]
%F{blue}└─%F{white}(%F{red}%~%F{white}) %#%F{10}>%F{white} \"";
    };

    xdg.configFile."kitty".recursive = true;
    xdg.configFile."kitty".source = ../../kitty;
    xdg.configFile."hypr".source = ../../hyprland;
    xdg.configFile."fuzzel".source = ../../fuzzel;
    xdg.configFile."waybar".source = ../../waybar;
  };

}
