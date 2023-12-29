{
  home.sessionVariables.BROWSER = "firefox";

  programs.firefox = {
    enable = true;
    profiles =
      let
        baseSettings = {
          "apz.gtk.pangesture.delta_mode" = 2;
          "signon.rememberSignons" = false;
        };
        baseSearch = {
          force = true;
        };
      in
      {
        "Andrew" = {
          isDefault = true;
          id = 0;
          settings = baseSettings;
          search = baseSearch;
        };
      };
  };
}
