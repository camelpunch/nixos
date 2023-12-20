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
      url = "/home/andrew/workspace/git-mob";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, git-mob }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.andrew = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./.config/home-manager/home.nix
          ./.config/home-manager/neovim.nix
          ./.config/home-manager/git.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          git-mob = git-mob.packages.x86_64-linux.default;
          git.userName = "Andrew Bruce";
          git.userEmail = "me@andrewbruce.net";
        };
      };

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
