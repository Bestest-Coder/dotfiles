{
  lib,
  pkgs,
  fetchgit,
  stdenv,
  libGL,
  libvorbis,
  SDL2,
  libogg,
  mpg123,
  curl
}:
stdenv.mkDerivation rec {
  pname = "ironwail";
  version = "0.8.1";

  src = fetchgit {
    url = "https://github.com/andrei-drexler/ironwail.git";
    rev = "refs/tags/v${version}";
    hash = "sha256-h9P1nmdt6aGwqkb9X14syjWiJLXaIYyqffgpfY+/8e0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    libvorbis
    libGL
    SDL2
    libogg
    mpg123
    curl.dev
  ];

  preBuild = ''
    cd Quake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ironwail $out/bin
  '';
    
}
