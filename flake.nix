{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-mob = {
      url = "github:code-supply/rusty-git-mob";
      # url = "/home/andrew/workspace/rusty-git-mob";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, git-mob }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      callBox = name: import ./boxes/${name} {
        inherit nixpkgs system;
      };
    in
    {
      homeConfigurations.andrew = import ./home-manager {
        inherit home-manager pkgs git-mob;
      };

      colmena = {
        meta = {
          nixpkgs = pkgs;
          nodeSpecialArgs = {
            unhinged =
              let
                prefix-ipv6 = "2001:8b0:b184:5567";
              in
              {
                inherit prefix-ipv6;
                ipv4 = "192.168.1.182";
                router-ipv4 = "192.168.1.1";
                router-ipv6 = "${prefix-ipv6}::1";
                ipv6 = "${prefix-ipv6}::2";
              };
          };
        };
        unhinged = import ./boxes/unhinged/configuration.nix;
      };

      nixosConfigurations = {
        fatty = callBox "fatty";
        p14s = callBox "p14s";
      };
    };
}
