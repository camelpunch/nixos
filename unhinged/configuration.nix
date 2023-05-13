# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unhinged-ipv4 = "192.168.1.182";
  prefix-ipv6 = "2001:8b0:b184:5567";
  router-ipv4 = "192.168.1.1";
  router-ipv6 = "${prefix-ipv6}::1";
  unhinged-ipv6 = "${prefix-ipv6}::2";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.blacklistedKernelModules = [
    "ath10k_pci"
    "btusb"
    "uvcvideo"
  ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9a963459-0310-4197-9c0d-26ecb1df10dd".device = "/dev/disk/by-uuid/9a963459-0310-4197-9c0d-26ecb1df10dd";
  boot.initrd.luks.devices."luks-9a963459-0310-4197-9c0d-26ecb1df10dd".keyFile = "/crypto_keyfile.bin";

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      authorizedKeys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFYJpKCj5tBJtJDwI3imbZ0pe9Vs47E5qirQ27a6XBxLcUkwrJXxKT6SZGJYGi0ZRqIkkVyWyASGPjKjQMumuS0= andrew@p14s" ];
      hostKeys = [ /boot/host_ecdsa_key ];
    };
  };

  boot.kernelParams = [ "consoleblank=5" ];

  systemd.network = {
    enable = true;

    networks = {
      enp0s20f0u2 = {
        matchConfig = {
          Name = "enp0s20f0u2";
        };
        DHCP = "no";
        addresses = [
          { addressConfig = { Address = "${unhinged-ipv4}/24"; }; }
          { addressConfig = { Address = "${unhinged-ipv6}/64"; }; }
        ];
        dns = [
          "127.0.0.1"
          "::1"
        ];
        gateway = [
          "${router-ipv4}"
          "${router-ipv6}"
        ];
      };
    };
  };

  networking = {
    dhcpcd.enable = false;
    hostName = "unhinged";
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    servers = [
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
    extraConfig = ''
      no-hosts
      no-resolv
      no-poll
      address=/*.code.test/127.0.0.1
      address=/*.code.supply/${unhinged-ipv4}
      address=/*.code.supply/${unhinged-ipv6}
      address=/unhinged/${unhinged-ipv4}
      address=/unhinged/${unhinged-ipv6}
    '';
  };

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--cluster-cidr=10.42.0.0/16,fd42::/56"
      "--service-cidr=10.43.0.0/16,fd43::/112"
      "--node-ip=${unhinged-ipv4},${unhinged-ipv6}"
    ];
  };

  services.logind.lidSwitch = "ignore";

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    listenAddresses = [
      {
        addr = "[::]";
        port = 2222;
      }
      {
        addr = "0.0.0.0";
        port = 2222;
      }
    ];
    extraConfig = ''
      UseDNS no
    '';
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

  systemd.extraConfig = ''
    DefaultLimitNOFILE=1048576
  '';
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
