{
  lib,
  stdenv,
  appimageTools,
  fetchgit,
  makeDesktopItem,
  gcc,
  clang,
  cmake,
  gettext,
  harfbuzz,
  icu,
  pkgconf,
  SDL2,
  ffmpeg,
  #freeimage,
  freetype,
  libgit2,
  pugixml,
  poppler,
  libGL,
  alsa-lib,
  bluez
}:

let
  # icon = fetchurl {
  #   url = "https://statlocker.gg/favicon.ico";
  #   sha256 = "sha256-rVg8kw2Vz5v2FsOQIld7EKpQjBIJzAXAui0Kvxw06MQ=";
  # };

  # desktopItem = makeDesktopItem {
  #   name = pname;
  #   exec = "statlocker-companion";
  #   icon = icon;
  #   desktopName = pname;
  #   genericName = "Statlocker companion";
  #   categories = [ "Application" ];
  # };
in
stdenv.mkDerivation rec {
  pname = "ES-DE";
  version = "3.4.1";

  src = fetchgit {
    url = "https://gitlab.com/liberodark/emulationstation-de.git";
    #rev = "refs/tags/v${version}";
    rev = "refs/heads/freeimage";
    #hash = "sha256-MVmJIdxwEG3wgvwbhuIEYCxKaYss/3hq9xszGLjZ1Xw=";
    hash = "sha256-qPSLxzwZlvtvH/XdovzPbqp/Y92DCyQinlv1L1a+N30=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    gcc
    clang
    cmake
    gettext
    harfbuzz
    icu
    pkgconf
    SDL2
    ffmpeg
    #freeimage
    freetype
    libgit2
    pugixml
    poppler
    libGL
    alsa-lib
    bluez
  ];

  cmakeFlags = [
    "-DAPPLICATION_UPDATER=off"
  ];

  meta = {
    description = "";
    homepage = "https://statlocker.gg/deadlock-companion-app";
    #downloadPage = "https://github.com/ZUGFeRD/quba-viewer/releases";
    #license = lib.licenses.asl20;
    # mainProgram = "statlocker-companion_amd64.AppImage";
    # sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ "techlord18@gmail.com" ];
    platforms = [ "x86_64-linux" ];
  };
}
