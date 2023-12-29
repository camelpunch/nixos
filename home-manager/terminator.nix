{
  programs.terminator = {
    enable = true;
    config = {
      profiles.default = {
        background_color = "#282828";
        cursor_color = "#aaaaaa";
        font = "Source Code Pro Semibold 14";
        foreground_color = "#ebdbb2";
        palette = "#282828:#cc241d:#98971a:#d79921:#458588:#b16286:#689d6a:#a89984:#928374:#fb4934:#b8bb26:#fabd2f:#83a598:#d3869b:#8ec07c:#ebdbb2";
        scrollback_infinite = true;
        scrollbar_position = "disabled";
        show_titlebar = false;
        use_system_font = false;
      };
      keybindings = {
        full_screen = "<Alt>Return";
      };
    };
  };
}
