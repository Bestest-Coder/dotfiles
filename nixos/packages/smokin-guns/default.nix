{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libGL,
  openal,
  curl
}:

stdenv.mkDerivation rec {
  pname = "Smokin Guns";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "smokin-guns";
    repo = "SmokinGuns";
    rev = "v${version}";
    hash = "sha256-8/ar5UsP8VqW//3qcoaS3scQHaCKB4UDZfc0y1ELfEc=";
  };

  buildInputs = [
    SDL2
    libGL
    openal
    curl
  ];

  meta = with lib; {
    description = "A quake 3 mod inspired by spaghetti westerns";
    homepage = "https://www.smokin-guns.org/";
    licenses = licenses.gpl2;
    maintainers = [ "bestest" ];
  };
}
