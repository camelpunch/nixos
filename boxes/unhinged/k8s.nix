{ pkgs
, ...
}:

let
  prefix-ipv6 = "2001:8b0:b184:5567";
  ipv4 = "192.168.1.182";
  ipv6 = "${prefix-ipv6}::2";
in
{
  environment.systemPackages = with pkgs; [
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
}
