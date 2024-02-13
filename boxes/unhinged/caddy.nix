{ websites, ... }:

{
  services.caddy = {
    enable = true;

    email = "me@andrewbruce.net";

    virtualHosts = {
      andrewbruce = {
        hostName = "www.andrewbruce.net";
        serverAliases = [
          "andrewbruce.net"
        ];

        extraConfig = ''
          encode gzip
          root * ${websites.andrewbruce}
          file_server
        '';
      };
    };
  };
}
