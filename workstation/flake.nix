{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      follows = "musnix/nixpkgs";
    };
    musnix.url = "github:musnix/musnix";
  };

  outputs = inputs @ {
    self,
    musnix,
    nixpkgs,
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.p14s = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        musnix.nixosModules.musnix
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
