{ nixpkgs, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    ../../modules/steam.nix
  ];
}