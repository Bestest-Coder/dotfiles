{pkgs, ...}:
{
  home.stateVersion = "23.11";
  xdg.configFile."nvim".recursive = true;
  xdg.configFile."nvim".source =  ../../neovim;

  #xdg.configFile."kitty".recursive = true;
  #xdg.configFile."kitty".source = ../../kitty;
  xdg.configFile."wezterm".source = ../../wezterm;
  xdg.configFile."fuzzel".source = ../../fuzzel;
  xdg.configFile."waybar".source = ../../waybar;
  xdg.configFile."dunst".source = ../../dunst;

  xdg.configFile."hypr".recursive = true;
  xdg.configFile."hypr".source = ../../hyprland;

  xdg.configFile."niri".recursive = true;
  xdg.configFile."niri".source = ../../niri;

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
    steam-extest = {
      name = "Steam on prime with ex-test";
      genericName = "Application";
      icon = "steam";
      # may need -cef-disable-gpu if "use GPU acceleration" is not turned off in interface settings
      exec = "prime-run env LD_PRELOAD=${pkgs.extest}/target/i686-unknown-linux-gnu/release/libextest.so steam %U";
      terminal = false;
      categories = ["Game"];
      mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "text/plain" = "nvim.desktop";
      "application/zip" = "ark.desktop";
      "application/pdf" = "firefox.desktop";
      "image/png" = "feh";
    };
  };

}
