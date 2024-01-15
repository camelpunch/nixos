{ lib
, pkgs
, ...
}:

with lib;

{
  imports = [
    ../common/locale.nix
    ../common/user.nix
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

    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
