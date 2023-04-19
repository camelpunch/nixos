{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    musnix.url = github:musnix/musnix;
  };

  outputs = inputs@{ self, musnix, nixpkgs }: rec {
    nixosConfigurations.p14s = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        musnix.nixosModules.musnix
        ./configuration.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
