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
      url = "github:code-supply/git-mob";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, git-mob }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      callBox = name: import ./boxes/${name} { inherit nixpkgs system; };
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
        fatty = callBox "fatty";
        p14s = callBox "p14s";
        unhinged = callBox "unhinged";
      };
    };
}
