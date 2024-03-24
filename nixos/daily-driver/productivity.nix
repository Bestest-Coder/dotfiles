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
    unstable.blender
    unstable.godot_4
    texlive.combined.scheme-medium
    zathura
    qalculate-gtk
    libsForQt5.kdenlive
    gimp
    audacity

    nodejs_21
    python3
    scons
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
