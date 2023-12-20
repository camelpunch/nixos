{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        fatty = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./fatty/configuration.nix
            ./modules/steam.nix
          ];
        };

        p14s = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./workstation/configuration.nix
            ./modules/steam.nix
          ];
        };

        unhinged = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./unhinged/configuration.nix
          ];
        };
      };
    };
}
