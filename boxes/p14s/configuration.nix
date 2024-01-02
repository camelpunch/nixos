{ pkgs
, ...
}: {
  imports = [
    ./nix.nix
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./locale.nix
    ./gui.nix
    ./sound.nix
  ];

  virtualisation.docker.enable = true;
  services.printing.enable = true;
  services.fwupd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrew = {
    isNormalUser = true;
    description = "Andrew Bruce";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "wheel"
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "andrew";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.ssh.startAgent = false;
  services.pcscd.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
