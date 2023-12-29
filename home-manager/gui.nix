{ pkgs, ... }:
{
  home = {
    file = {
      gnome-keyring-ssh = {
        target = ".config/autostart/gnome-keyring-ssh.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Hidden=true
        '';
      };
    };

    packages = with pkgs; [
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
  };
}
