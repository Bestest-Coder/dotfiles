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
    blender
    (texlive.combine { inherit (texlive)
      scheme-full
    ;})
    zathura
    qalculate-gtk
    davinci-resolve
    unstable.gimp3
    audacity
    slack

    nodejs_22 #need for neovim coc :woeisme:
    nixd
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
