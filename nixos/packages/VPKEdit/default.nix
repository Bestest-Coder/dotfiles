{
  lib,
  pkgs,
  fetchFromGitHub,
  fetchgit,
  stdenv,
  cmake,
  qt6,
  libxkbcommon,
  git
}:
stdenv.mkDerivation rec {
  pname = "VPKEdit";
  version = "4.4.1";

  src = fetchgit {
    url = "https://github.com/craftablescience/VPKEdit.git";
    rev = "refs/tags/v${version}";
    hash = "sha256-cQbkbRwwX0KDzIhsXKIwuo/GDSGwhtvlnkl+3SYI4Ao=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.full
    libxkbcommon
    git
  ];

  postInstall = ''
    cp VPKEditcli $out/bin
    cp VPKEdit $out/bin
  '';
    
}
