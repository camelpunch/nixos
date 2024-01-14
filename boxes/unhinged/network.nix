{ config
, lib
, ...
}:

with lib;

let
  cfg = config.services.unhinged-network;
in
{
  options = {
    services.unhinged-network = {
      ipv4 = mkOption {
        type = types.str;
      };
      ipv6 = mkOption {
        type = types.str;
      };
      router-ipv4 = mkOption {
        type = types.str;
      };
      router-ipv6 = mkOption {
        type = types.str;
      };
    };

    config = {
      boot.initrd.network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = [ "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFYJpKCj5tBJtJDwI3imbZ0pe9Vs47E5qirQ27a6XBxLcUkwrJXxKT6SZGJYGi0ZRqIkkVyWyASGPjKjQMumuS0= andrew@p14s" ];
          hostKeys = [ /boot/host_ecdsa_key ];
        };
      };

      systemd.network = {
        enable = true;

        networks = {
          enp0s20f0u2 = {
            matchConfig = {
              Name = "enp0s20f0u2";
            };
            DHCP = "no";
            addresses = [
              { addressConfig = { Address = "${cfg.ipv4}/24"; }; }
              { addressConfig = { Address = "${cfg.ipv6}/64"; }; }
            ];
            dns = [
              "127.0.0.1"
              "::1"
            ];
            gateway = [
              "${cfg.router-ipv4}"
              "${cfg.router-ipv6}"
            ];
          };
        };
      };

      networking = {
        dhcpcd.enable = false;
        firewall.enable = false;
        hostName = "unhinged";
        # useNetworkd = true;
      };

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "yes";
        };
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
    };
  };
}
