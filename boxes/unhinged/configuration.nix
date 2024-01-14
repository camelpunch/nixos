{ lib
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./dnsmasq.nix
    ./hardware-configuration.nix
    ./k8s.nix
    ./network.nix
    ./nix.nix
    ./postgresql.nix
    ./tweaks.nix
  ];

  config = {
    services.unhinged-network =
      let
        prefix-ipv6 = "2001:8b0:b184:5567";
      in
      {
        router-ipv4 = "192.168.1.1";
        router-ipv6 = "${prefix-ipv6}::1";
        ipv4 = "192.168.1.182";
        ipv6 = "${prefix-ipv6}::2";
      };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    # Setup keyfile
    boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    # Enable swap on luks
    boot.initrd.luks.devices."luks-9a963459-0310-4197-9c0d-26ecb1df10dd".device = "/dev/disk/by-uuid/9a963459-0310-4197-9c0d-26ecb1df10dd";
    boot.initrd.luks.devices."luks-9a963459-0310-4197-9c0d-26ecb1df10dd".keyFile = "/crypto_keyfile.bin";

    time.timeZone = "Europe/London";

    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.andrew = {
      isNormalUser = true;
      description = "Andrew Bruce";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        dig
        lsof
      ];
    };

    environment.systemPackages = with pkgs; [
      git
    ];

    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
