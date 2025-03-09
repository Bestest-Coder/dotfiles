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
          cd ~/dotfiles
          kitty nvim
          ;;

      "Update - Switch")
          kitty zsh -c "sudo nixos-rebuild switch; zsh"
          ;;
      
      "Update - Boot")
          kitty zsh -c "sudo nixos-rebuild boot; zsh"
          ;;
  esac
''
