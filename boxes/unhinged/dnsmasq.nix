let
  prefix-ipv6 = "2001:8b0:b184:5567";
  ipv4 = "192.168.1.182";
  ipv6 = "${prefix-ipv6}::2";
in
{
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
      address=/*.code.supply/${ipv4}
      address=/*.code.supply/${ipv6}
      address=/unhinged/${ipv4}
      address=/unhinged/${ipv6}
    '';
  };
}
