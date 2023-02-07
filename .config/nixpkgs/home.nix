{ config, lib, pkgs, ... }:

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

  xdg.desktopEntries = with pkgs; {
    ardour7 = {
      name = "Ardour";
      comment = "Ardour Digital Audio Workstation";
      exec = "env LV2_PATH=/home/andrew/.nix-profile/lib/lv2 ardour7";
      icon = "ardour7";
      terminal = false;
      mimeType = [ "application/x-ardour" ];
      type = "Application";
      categories = [ "AudioVideo" "Audio" "X-AudioEditing" "X-Recorders" "X-Multitrack" "X-Jack" ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "zoom"
  ];

  home.packages = with pkgs;
    let
      audioPlugins = [
        aether-lv2
        airwindows-lv2
        ams-lv2
        distrho
        drumgizmo
        faust
        FIL-plugins
        gxmatcheq-lv2
        gxplugins-lv2
        ir.lv2
        LibreArp
        mod-arpeggiator-lv2
        rkrlv2
        surge-XT
        tamgamp.lv2
        x42-plugins
      ];
      audioPrograms = [
        ardour
        audacity
        carla
        guitarix
        helvum
        qjackctl
        qpwgraph
      ];
      security = [
        gnupg
        pass
        pinentry-gnome
        yubikey-manager
      ];
      unfree = [
        zoom-us
      ];
    in
    [
      dig
      du-dust
      file
      git
      gnome3.gnome-tweaks
      google-cloud-sdk
      htop
      iftop
      k9s
      lsof
      rnix-lsp
      signal-desktop
      sysfsutils
      wget
      wl-clipboard
    ] ++ audioPrograms ++ audioPlugins ++ security ++ unfree;

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

  programs.firefox = {
    enable = true;
    profiles =
      let
        baseSettings = {
          "apz.gtk.pangesture.delta_mode" = 2;
          "signon.rememberSignons" = false;
        };
        baseSearch = {
          force = true;
        };
      in
      {
        "Andrew" = {
          isDefault = true;
          id = 0;
          settings = baseSettings;
          search = baseSearch;
        };

        "Ignition Works" = {
          id = 1;
          settings = baseSettings;
          search = baseSearch;
        };
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
