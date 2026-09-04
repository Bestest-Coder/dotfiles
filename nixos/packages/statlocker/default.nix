{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem
}:

let
  version = "3.0";
  pname = "statlocker-companion";

  src = fetchurl {
    url = "https://updates.statlocker.gg/companion/download/statlocker-companion_amd64.AppImage";
    hash = "sha256-tsqxN4Wzye9HWU7Z/3itXM+YDr5P7dGCk3IIaIDrbZM=";
  };

  icon = fetchurl {
    url = "https://statlocker.gg/favicon.ico";
    sha256 = "sha256-rVg8kw2Vz5v2FsOQIld7EKpQjBIJzAXAui0Kvxw06MQ=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "statlocker-companion";
    icon = icon;
    desktopName = pname;
    genericName = "Statlocker companion";
    categories = [ "Application" ];
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  meta = {
    description = "Official companion app for Statlocker.gg";
    homepage = "https://statlocker.gg/deadlock-companion-app";
    #downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
    #license = lib.licenses.asl20;
    mainProgram = "statlocker-companion_amd64.AppImage";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ "techlord18@gmail.com" ];
    platforms = [ "x86_64-linux" ];
  };
}
