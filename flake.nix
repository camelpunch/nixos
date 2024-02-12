{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix = {
      url = "nix/2.20.1";
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

  outputs = { self, nix, nixpkgs, home-manager, git-mob }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      callBox = name: import ./boxes/${name} {
        nix = nix.packages.${system}.nix;
        inherit nixpkgs system;
      };
    in
    {
      homeConfigurations.andrew = import ./home-manager {
        inherit home-manager pkgs git-mob;
      };

      nixosModules = {
        kitty = import ./home-manager/kitty.nix;
      };

      nixosConfigurations = {
        fatty = callBox "fatty";
        p14s = callBox "p14s";
        unhinged = callBox "unhinged";
      };
    };
}
