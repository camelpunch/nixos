{ git, git-mob, ... }: {
  programs.git = {
    enable = true;
    userName = git.userName;
    userEmail = git.userEmail;
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
      init = {
        defaultBranch = "main";
      };
    };
  };
}
