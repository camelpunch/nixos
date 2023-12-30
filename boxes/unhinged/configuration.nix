{ pkgs
, ipv4
, ipv6
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./tweaks.nix
    ./network.nix
    ./dnsmasq.nix
  ];

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    k3s
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--cluster-cidr=10.42.0.0/16,fd42::/56"
      "--service-cidr=10.43.0.0/16,fd43::/112"
      "--node-ip=${ipv4},${ipv6}"
    ];
  };

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = [
      "affable"
      "atc"
      "hosting"
    ];
    ensureUsers = [
      {
        name = "affable";
        ensurePermissions = {
          "DATABASE affable" = "ALL PRIVILEGES";
        };
      }
      {
        name = "hosting";
        ensurePermissions = {
          "DATABASE hosting" = "ALL PRIVILEGES";
        };
      }
      {
        name = "concourse";
        ensurePermissions = {
          "DATABASE atc" = "ALL PRIVILEGES";
        };
      }
    ];
    authentication = ''
      # type  database  user      address           method
      local   all       all                         trust
      host    all       all       127.0.0.1/32      trust
      host    all       all       ::1/128           trust
      host    affable   affable   192.168.1.0/24    trust
      host    affable   affable   10.42.0.0/16      trust
      host    hosting   hosting   192.168.1.0/24    trust
      host    hosting   hosting   10.42.0.0/16      trust
      host    atc       concourse 192.168.1.0/24    trust
      host    atc       concourse 10.42.0.0/16      trust
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
