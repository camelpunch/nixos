{ git-mob, ... }: {
  programs.git = {
    enable = true;
    userName = "Andrew Bruce";
    userEmail = "me@andrewbruce.net";
    aliases = {
      br = "branch";
      ci = "commit --verbose";
      co = "checkout";
      di = "diff";
      st = "status";
    };
    hooks = {
      prepare-commit-msg = "${git-mob}/bin/git-mob-prepare-commit-msg";
    };
    extraConfig = {
      commit.template = "~/.gitmessage.txt";
      init = {
        defaultBranch = "main";
      };
    };
  };
}
