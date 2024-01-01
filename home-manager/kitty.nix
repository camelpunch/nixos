{ pkgs, ... }: {
  fonts.fontconfig.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
      size = 14;
    };
    settings = {
      hide_window_decorations = "yes";
    };
  };
}
