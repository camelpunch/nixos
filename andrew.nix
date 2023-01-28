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
    programs.bash = {
      enable = true;
      bashrcExtra = ''
export PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
      '';
    };
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
    programs.terminator = {
      enable = true;
      config = {
        profiles.default = {
          background_color = "#282828";
          cursor_color = "#aaaaaa";
          font = "Source Code Pro Semibold 16";
          foreground_color = "#ebdbb2";
          palette = "#282828:#cc241d:#98971a:#d79921:#458588:#b16286:#689d6a:#a89984:#928374:#fb4934:#b8bb26:#fabd2f:#83a598:#d3869b:#8ec07c:#ebdbb2";
          scrollback_infinite = true;
          scrollbar_position = "disabled";
          show_titlebar = false;
          use_system_font = false;
        };
      };
    };
  };
}
