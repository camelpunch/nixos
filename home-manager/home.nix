{ lib
, pkgs
, git-mob
, ...
}: {
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

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/workspace/google-cloud-sdk/bin"
    ];
    sessionVariables = {
      BROWSER = "firefox";
      LV2_PATH = "/home/andrew/.nix-profile/lib/lv2";
    };

    packages = with pkgs; let
      audioPlugins = [
        aether-lv2
        airwindows-lv2
        ams-lv2
        bespokesynth
        bschaffl
        calf
        ChowKick
        distrho
        drumgizmo
        drumkv1
        faust
        FIL-plugins
        geonkick
        gxmatcheq-lv2
        gxplugins-lv2
        ir.lv2
        LibreArp
        lsp-plugins
        mod-arpeggiator-lv2
        ninjas2
        rkrlv2
        sfizz
        surge-XT
        tamgamp.lv2
        x42-plugins
        zynaddsubfx
      ];
      audioPrograms = [
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
      graphicsPrograms = [
        ffmpeg
        gimp
        imagemagick
      ];
      security = [
        gnupg
        pass
        pinentry-gnome
        yubikey-manager
      ];
      unfree = [
        skypeforlinux
        spotify
        zoom-us
      ];
    in
    [
      alejandra
      awscli2
      binutils
      bless
      calibre
      cntr
      dig
      dive
      du-dust
      file
      git-mob
      gnome3.gnome-tweaks
      htop
      iftop
      jq
      kubectl
      kubernetes-helm
      libreoffice
      lsof
      nil
      nix-index
      nixops_unstable
      nixos-generators
      nixpkgs-fmt
      nix-tree
      nmap
      pciutils
      ripgrep
      rnix-lsp
      signal-desktop
      sumneko-lua-language-server
      sysfsutils
      transmission-gtk
      unzip
      usbutils
      vlc
      wget
      whois
      wl-clipboard
      xclip
      xournal
      youtube-dl
      zip
    ]
    ++ audioPrograms
    ++ audioPlugins
    ++ graphicsPrograms
    ++ security
    ++ unfree;

    file = {
      pipewire-config =
        let
          json = pkgs.formats.json { };
        in
        {
          target = ".config/pipewire/pipewire.conf.d/92-low-latency.conf";
          source = json.generate "92-low-latency.conf" {
            context.properties = {
              default.clock.rate = 48000;
              default.clock.quantum = 16;
              default.clock.min-quantum = 16;
              default.clock.max-quantum = 16;
            };
          };

        };

      gnome-keyring-ssh = {
        target = ".config/autostart/gnome-keyring-ssh.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Hidden=true
        '';
      };
    };
  };
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    k9s = {
      enable = true;
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "unhinged" = {
          hostname = "192.168.1.182";
          port = 2222;
        };
      };
    };

    bottom.enable = true;

    bash = {
      enable = true;
      bashrcExtra = ''
        export PS1="\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\] "
        source <(k3s completion bash)
        if command -v fly > /dev/null
        then
          source <(fly completion --shell=bash)
        fi
        bind 'Space: magic-space'
      '';
    };

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    firefox = {
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
        };
    };

    readline = {
      enable = true;
      bindings = {
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
      };
      variables = {
        completion-ignore-case = true;
      };
    };

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

    tmate.enable = true;

    tmux.enable = true;
  };

  xdg.desktopEntries = {
    audacity = {
      name = "Audacity";
      genericName = "Sound Editor";
      icon = "audacity";
      type = "Application";
      categories = [ "AudioVideo" "Audio" "AudioVideoEditing" ];
      exec = "env GDK_BACKEND=x11 audacity %F";
      mimeType = [
        "application/x-audacity-project"
        "audio/aac"
        "audio/ac3"
        "audio/mp4"
        "audio/x-ms-wma"
        "video/mpeg"
        "audio/flac"
        "audio/x-flac"
        "audio/mpeg"
        "application/ogg"
        "audio/x-vorbis+ogg"
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "skypeforlinux"
      "spotify"
      "tetrio-desktop"
      "zoom"
    ];

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
