{pkgs, ...}:
{
  # things that are used to do work in
  # i.e. email client, notes software, compilers/interpreters
  environment.systemPackages = with pkgs; [
    obsidian
    thunderbird
    libreoffice-fresh
    blender
    godot_4
    texlive.combined.scheme-medium
    zathura
    python3
    scons
  ];
}
