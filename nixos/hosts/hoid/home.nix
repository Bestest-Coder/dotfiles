{pkgs, config, ...}:
let
  custom-envision = (pkgs.lib.callPackageWith (pkgs.unstable) ../../packages/envision-mesa {});
in {
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
  #xdg.configFile."openxr/1/active_runtime.json".source = "${custom-envision}/share/openxr/1/openxr_monado.json";
#   xdg.configFile."openvr/openvrpaths.vrpath".text = ''
#   {
#     "config" :
#     [
#       "${config.xdg.dataHome}/Steam/config"
#     ],
#     "external_drivers" : null,
#     "jsonid" : "vrpathreg",
#     "log" :
#     [
#       "${config.xdg.dataHome}/Steam/logs"
#     ],
#     "runtime" :
#     [
#       "${pkgs.unstable.opencomposite}/lib/opencomposite"
#     ],
#     "version" : 1
#   }
# '';
}
