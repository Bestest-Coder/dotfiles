{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  libsamplerate,
  fluidsynth,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "apdoom";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Daivuk";
    repo = "apdoom";
    rev = "${version}";
    sha256 = "";
  };

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
    for script in $(grep -lr '^#!/usr/bin/env python3$'); do patchShebangs $script; done
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];
  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_net
    libsamplerate
    fluidsynth
  ];
  enableParallelBuilding = true;

  strictDeps = true;

  meta = {
    homepage = "https://github.com/Daivuk/apdoom";
    description = "Fork of Crispy Doom with Archipelago integration";
    longDescription = ''
      Archipelago Doom is a fork of Crispy Doom to allow multi-world features from Archipelago
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    #maintainers = with lib.maintainers; [ bestest ];
  };
}
