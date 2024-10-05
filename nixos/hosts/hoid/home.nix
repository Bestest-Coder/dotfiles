{
  imports = [
    ../../daily-driver/home.nix
  ];
  xdg.desktopEntries = {
    twad = {
      name = "twad";
      genericName = "Doom Launcher";
      exec = "twad";
      terminal = true;
      categories = ["Application" "Game"];
    };
  };
}
