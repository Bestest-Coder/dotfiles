{ lib
, pkgs
, ...
}:

pkgs.writeShellScriptBin "bestestscreenshot" ''
  slurp | grim -g - - | tee ~/screenshots/$(date +"%Y-%m-%d-%T") | wl-copy
''
