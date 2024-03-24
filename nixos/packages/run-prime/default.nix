{ lib
, pkgs
, ...
}:

pkgs.writeShellScriptBin "prime-run" "DRI_PRIME=0 $@"
