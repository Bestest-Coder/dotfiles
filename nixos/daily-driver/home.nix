{pkgs, ...}:
{
  home.stateVersion = "23.11";
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source =  ../../neovim;

  xdg.configFile."kitty".recursive = true;
  xdg.configFile."kitty".source = ../../kitty;
  xdg.configFile."fuzzel".source = ../../fuzzel;
  xdg.configFile."waybar".source = ../../waybar;
  xdg.configFile."dunst".source = ../../dunst;

  xdg.configFile."hypr".recursive = true;
  xdg.configFile."hypr".source = ../../hyprland;
  #imports = [
  #  ../../hyprland/hyprland.nix
  #];

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
      name = "Steam on prime";
      genericName = "Application";
      icon = "steam";
      # may need -cef-disable-gpu if "use GPU acceleration" is not turned off in interface settings
      exec = "prime-run steam %U";
      terminal = false;
      categories = ["Game"];
      mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
    };
  };

  #dconf.settings = {
  #  "org/gnome/desktop/interface" = {
  #    gtk-theme = "Adwaita:dark";
  #    icon-theme = "Adwaita:dark";
  #  };
  #};
}
