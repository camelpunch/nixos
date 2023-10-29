{
  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      nixosModules.steam = { config, ... }: {
        config = {
          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (pkgs.lib.getName pkg) [
              "steam"
              "steam-original"
              "steam-run"
            ];

          programs.steam.enable = true;
        };
      };
    };
}
