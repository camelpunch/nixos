{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Bruce";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  home-manager.users.andrew = { pkgs, ... }: {
    home.file = {
      gnome-keyring-ssh = {
        target = ".config/autostart/gnome-keyring-ssh.desktop";
        text = ''
  [Desktop Entry]
  Type=Application
  Hidden=true
        '';
      };
    };
    home.stateVersion = "22.11";
    home.packages = [
      pkgs.ardour
      pkgs.carla
      pkgs.firefox-wayland
      pkgs.gnome3.gnome-tweaks
      pkgs.helvum
      pkgs.pass
      pkgs.pinentry-gnome
      pkgs.qjackctl
      pkgs.qpwgraph
      pkgs.wl-clipboard
      pkgs.yubikey-manager
    ];
    programs.git = {
      enable = true;
      userName = "Andrew Bruce";
      userEmail = "me@andrewbruce.net";
      aliases = {
        br = "branch";
        ci = "commit --verbose";
        co = "checkout";
        di = "diff";
        st = "status";
      };
    };
  };
}
