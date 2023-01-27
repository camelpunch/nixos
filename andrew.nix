{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Bruce";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  home-manager.users.andrew = { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.packages = [
      pkgs.ardour
      pkgs.carla
      pkgs.firefox
      pkgs.helvum
      pkgs.pass
      pkgs.qjackctl
      pkgs.yubikey-manager
    ];
    programs.git = {
      enable = true;
      userName = "Andrew Bruce";
      userEmail = "me@andrewbruce.net";
      aliases = {
        ci = "commit --verbose";
        co = "checkout";
        st = "status";
        di = "diff";
      };
    };
  };
}
