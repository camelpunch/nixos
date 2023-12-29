{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bless
    calibre
    gnome3.gnome-tweaks
    libreoffice
    nixops_unstable
    nixos-generators
    signal-desktop
    transmission-gtk
    vlc
    wl-clipboard
    xclip
    xournal
    youtube-dl
  ];
}
