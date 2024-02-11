{pkgs, ...}:
{
  home.stateVersion = "23.11";
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source =  ../../neovim;

  xdg.configFile."kitty".recursive = true;
  xdg.configFile."kitty".source = ../../kitty;
  xdg.configFile."hypr".source = ../../hyprland;
  xdg.configFile."fuzzel".source = ../../fuzzel;
  xdg.configFile."waybar".source = ../../waybar;

  xdg.desktopEntries = {
    firefox-private = {
      name = "Firefox Private";
      genericName = "Web Browser";
      icon = "firefox";
      exec = "firefox --private-window %U";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
    };
    steam-prime = {
      name = "steam on prime";
      genericName = "Application";
      icon = "steam";
      exec = "DRI_PRIME=1 steam"; # assuming that the 2nd GPU is the better one to offload to
      terminal = false;
      categories = ["Game"];
      mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
    };
  };
}
