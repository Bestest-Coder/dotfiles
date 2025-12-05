{ lib
, pkgs
, ...
}:

pkgs.writeShellScriptBin "bestestoolscript" ''
  inputs="Open Dotfiles
  Update - Switch
  Update - Boot"

  choice=$(echo "$inputs" | fuzzel -d)

  case $choice in


      "Open Dotfiles")
          wezterm start -- nvim ~/dotfiles
          ;;

      "Update - Switch")
          wezterm start -- zsh -c "sudo nixos-rebuild switch; zsh"
          ;;
      
      "Update - Boot")
          wezterm start -- zsh -c "sudo nixos-rebuild boot; zsh"
          ;;
  esac
''
