{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    musnix.url = "github:musnix/musnix";
  };

  outputs = inputs@{ self, musnix, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.p14s = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          musnix.nixosModules.musnix
          ./configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
