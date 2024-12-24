{ lib, stdenv, fetchzip, autoPatchelfHook, makeDesktopItem, copyDesktopItems, curl, libGL, SDL2, libz, libogg }:
let
  versioned_curl = curl.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ ["--enable-versioned-symbols"];
  });
in
stdenv.mkDerivation rec {
  pname = "sm64coopdx";
  version = "v1.0.4";
  src = fetchzip {
    url = "https://github.com/coop-deluxe/sm64coopdx/releases/download/${version}/sm64coopdx_${version}_Linux_x86_64_OpenGL.zip";
    hash = "sha256-SrobMtQNe3EU8zoAkUi77bYeK7CeLIHxzideRjH+ZbE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    versioned_curl
    libGL
    SDL2
    libz
    libogg
  ];

  #preBuild = ''
  #  addAutoPatchelfSearchPath .
  #'';

  installPhase = ''
    mkdir -p $out/bin
    chmod +x sm64coopdx
    cp sm64coopdx $out/bin/sm64coopdx
    cp libdiscord_game_sdk.so $out/bin/libdiscord_game_sdk.so
    cp -r lang $out/bin/lang
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  desktopItem = (makeDesktopItem {
    name = pname;
    desktopName = pname;
    comment = meta.description;
    type = "Application";
    exec = "sm64coopdx";
    categories = [ "Game" ];
    keywords = [
      "mario"
      "mario64"
      "sm64"
      "coop"
    ];
  });

  meta = with lib; {
    description = "An online multiplayer project for the Super Mario 64 PC port";
    homepage = "https://sm64coopdx.com/";
    maintainers = [];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sm64coopdx";
  };
}
