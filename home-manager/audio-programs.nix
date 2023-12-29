{ pkgs, ... }:
{
  home.packages = with pkgs; [
    abcde
    ardour
    audacity
    carla
    easyeffects
    elektroid
    ft2-clone
    helvum
    hydrogen
    lmms
    mixxx
    pianobooster
    polyphone
    qjackctl
    qpwgraph
    scdl
    sooperlooper
  ];
}
