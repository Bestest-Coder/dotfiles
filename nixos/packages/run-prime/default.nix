{ lib
, stdenvNoCC
, nixpkgs
}:

nixpkgs.writeShellScriptBin "prime-run" "DRI_PRIME=1 $@"
