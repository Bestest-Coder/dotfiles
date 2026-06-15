{
  lib,
  pkgs,
  fetchgit,
  stdenv,
  clang-tools,
  gettext,
  harfbuzz,
  icu,
  SDL2,
  ffmpeg,

}:
stdenv.mkDerivation rec {
  pname = "emulationstation-de";
  version = "3.4.1";

  src = fetchgit {
    url = "https://github.com/andrei-drexler/ironwail.git";
    rev = "refs/tags/v${version}";
    hash = "sha256-h9P1nmdt6aGwqkb9X14syjWiJLXaIYyqffgpfY+/8e0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    clang-tools
  ];

  preBuild = ''
    cd Quake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ironwail $out/bin
  '';
    
}
