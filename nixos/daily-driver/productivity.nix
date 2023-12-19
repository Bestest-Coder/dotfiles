{pkgs, ...}:
{
  # things that are used to do work in
  # i.e. email client, notes software, compilers/interpreters
  environment.systemPackages = with pkgs; [
    obsidian
    thunderbird
    libreoffice-fresh
    hunspell #libreoffice spellcheck
    hunspellDicts.en_US
    blender
    godot_4
    texlive.combined.scheme-medium
    zathura
    python3
    scons
    qalculate-gtk
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
