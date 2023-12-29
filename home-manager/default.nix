{ home-manager, pkgs, git-mob }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    ./audio-plugins.nix
    ./audio-programs.nix
    ./cli.nix
    ./dev.nix
    ./git.nix
    ./graphics.nix
    ./gui.nix
    ./home.nix
    ./kitty.nix
    ./neovim.nix
    ./unfree.nix
  ];

  extraSpecialArgs = {
    git-mob = git-mob.packages.x86_64-linux.default;
    git.userName = "Andrew Bruce";
    git.userEmail = "me@andrewbruce.net";
  };
}
