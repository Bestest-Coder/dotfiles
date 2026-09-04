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
    (texliveSmall.withPackages (ps: with ps; [
      scheme-full
    ]))
    zathura
    qalculate-gtk
    kdePackages.kdenlive
    unstable.gimp3
    #audacity

  ];

  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-25.9.0"
  # ];
}
