{pkgs, ...}:
{
  # things that are used to do work in
  # i.e. email client, notes software, compilers/interpreters
  environment.systemPackages = with pkgs; [
    unstable.obsidian
    thunderbird
    libreoffice-fresh
    hunspell #libreoffice spellcheck
    hunspellDicts.en_US
    unstable.blender
    unstable.godot_4
    texlive.combined.scheme-medium
    zathura
    python3
    scons
    qalculate-gtk
    libsForQt5.kdenlive
  ];

  pkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
