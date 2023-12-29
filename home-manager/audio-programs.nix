{ pkgs, ... }:
{
  home = {
    file = {
      pipewire-config =
        let
          json = pkgs.formats.json { };
        in
        {
          target = ".config/pipewire/pipewire.conf.d/92-low-latency.conf";
          source = json.generate "92-low-latency.conf" {
            context.properties = {
              default.clock.rate = 48000;
              default.clock.quantum = 16;
              default.clock.min-quantum = 16;
              default.clock.max-quantum = 16;
            };
          };

        };
    };

    packages = with pkgs; [
      abcde
      ardour
      audacity
      carla
      easyeffects
      elektroid
      ft2-clone
      helvum
      hydrogen
      lmms
      mixxx
      pianobooster
      polyphone
      qjackctl
      qpwgraph
      scdl
      sooperlooper
    ];
  };
}
