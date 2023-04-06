{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.p14s = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
