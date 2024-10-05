{ lib, stdenv, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "twad";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "zmnpl";
    repo = "twad";
    rev = "v${version}";
    hash = "sha256-5vVxhSz0Gs/JzyOXsF0Ny9oRgG8BV2ukTS20gwEBu5E=";
  };

  vendorHash = "sha256-+H3nGn/EnAqkYOrr1E0OH6gJ4nrZstj2NLXf1z9CmmQ=";

  meta = with lib; {
    description = "A terminal based wad manager";
    homepage = "https://github.com/zmnpl/twad";
    license = licenses.mit;
    maintainers = [ "bestest" ];
  };
}
