{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ardour
    cargo
    carla
    firefox-wayland
    gnome3.gnome-tweaks
    google-cloud-sdk
    helvum
    k9s
    pass
    pinentry-gnome
    qjackctl
    qpwgraph
    rustc
    signal-desktop
    wl-clipboard
    yubikey-manager
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
    export PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
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

  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      completion-ignore-case = true;
    };
    extraConfig = ''
      Space: magic-space
    '';
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

  programs.tmate.enable = true;

  programs.tmux.enable = true;

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
}
