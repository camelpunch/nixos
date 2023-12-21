{ home-manager, pkgs, git-mob }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    ./home.nix
    ./neovim.nix
    ./git.nix
  ];

  extraSpecialArgs = {
    git-mob = git-mob.packages.x86_64-linux.default;
    git.userName = "Andrew Bruce";
    git.userEmail = "me@andrewbruce.net";
  };
}
