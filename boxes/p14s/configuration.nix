{ lib
, pkgs
, ...
}: {
  imports = [
    ./nix.nix
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./locale.nix
  ];

  virtualisation.docker.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;

  services.fwupd.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode=666"
      "--cluster-cidr=10.42.0.0/16,fd42::/56"
      "--service-cidr=10.43.0.0/16,fd43::/112"
      "--node-ip=192.168.1.128,2001:8b0:b184:5567:c33f:dabf:ae3b:f8d0"
    ];
  };
  systemd.services.k3s.wantedBy = lib.mkForce [ ];

  # Scarlett 18i8 config
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8214 device_setup=1
  '';

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "-1";
    }
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Bruce";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "andrew";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    k3s
    alsa-scarlett-gui
  ];

  programs.ssh.startAgent = false;
  services.pcscd.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
