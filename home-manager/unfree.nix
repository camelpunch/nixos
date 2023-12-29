{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "skypeforlinux"
      "spotify"
      "tetrio-desktop"
      "zoom"
    ];

  home.packages = with pkgs; [
    skypeforlinux
    spotify
    zoom-us
  ];
}
