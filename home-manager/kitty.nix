{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
      size = 18;
    };
  };
}