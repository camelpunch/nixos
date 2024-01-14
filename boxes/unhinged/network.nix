let
  prefix-ipv6 = "2001:8b0:b184:5567";
  ipv4 = "192.168.1.182";
  ipv6 = "${prefix-ipv6}::2";
  router-ipv4 = "192.168.1.1";
  router-ipv6 = "${prefix-ipv6}::1";
in
{
  systemd.network = {
    enable = true;

    networks = {
      enp0s20f0u2 = {
        matchConfig = {
          Name = "enp0s20f0u2";
        };
        DHCP = "no";
        addresses = [
          { addressConfig = { Address = "${ipv4}/24"; }; }
          { addressConfig = { Address = "${ipv6}/64"; }; }
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
    useDHCP = false;
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
}
