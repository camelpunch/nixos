{ config
, pkgs
, ...
}:

let
  networkCfg = config.services.unhinged-network;
  ipv4 = networkCfg.ipv4;
  ipv6 = networkCfg.ipv6;
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
