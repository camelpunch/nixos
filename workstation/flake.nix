{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    common = {
      url = "../common";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, common }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.p14s = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          common.nixosModules.steam
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
