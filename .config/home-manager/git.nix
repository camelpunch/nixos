{ git, ... }: {
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
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      commit = {
        template = "~/.gitmessage.txt";
      };
    };
  };
}
