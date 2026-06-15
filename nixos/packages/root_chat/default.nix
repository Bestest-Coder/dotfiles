{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "root_chat";
  version = "latest";

  src = fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "";
  };

  extraInstallCommands = ''
    substituteInPlace $out/share/applications/root.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  '';

