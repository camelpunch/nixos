{
  imports = [
    ./boot.nix
    ./gpg-ssh.nix
    ./gui.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./sound.nix
    ./user.nix
  ];

  services.fwupd.enable = true;
  services.printing.enable = true;

  virtualisation.docker.enable = true;

  system.stateVersion = "22.11"; # Did you read the comment?
}
