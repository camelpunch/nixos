{
  fonts.fontconfig.enable = true;

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "andrew";
    homeDirectory = "/home/andrew";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    terminator = {
      enable = true;
      config = {
        profiles.default = {
          background_color = "#282828";
          cursor_color = "#aaaaaa";
          font = "Source Code Pro Semibold 14";
          foreground_color = "#ebdbb2";
          palette = "#282828:#cc241d:#98971a:#d79921:#458588:#b16286:#689d6a:#a89984:#928374:#fb4934:#b8bb26:#fabd2f:#83a598:#d3869b:#8ec07c:#ebdbb2";
          scrollback_infinite = true;
          scrollbar_position = "disabled";
          show_titlebar = false;
          use_system_font = false;
        };
        keybindings = {
          full_screen = "<Alt>Return";
        };
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:ctrl_modifier" ];
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };
}
