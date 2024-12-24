{pkgs, nixpkgs, ...}:
{
  # things that are used to do work in
  # i.e. email client, notes software, compilers/interpreters
  environment.systemPackages = with pkgs; [
    obsidian
    thunderbird
    libreoffice-fresh
    hunspell #libreoffice spellcheck
    hunspellDicts.en_US
    #unstable.blender
    blender
    unstable.godot_4
    #(callPackage ../packages/godot4-mono {})
    #godot4-mono
    (texlive.combine { inherit (texlive)
      scheme-full
    ;})
    zathura
    qalculate-gtk
    kdePackages.kdenlive
    gimp
    audacity
    slack

    nodejs_22 #need for neovim coc :woeisme:
    nixd
    #python3
    #scons
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
