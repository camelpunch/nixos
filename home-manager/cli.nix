{ pkgs, git-mob, ... }:
{
  home = {
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/workspace/google-cloud-sdk/bin"
    ];

    packages = with pkgs; [
      awscli2
      binutils
      cntr
      dig
      dive
      du-dust
      file
      git-mob
      gnupg
      htop
      iftop
      jq
      lsof
      nix-index
      nix-tree
      nmap
      pass
      pciutils
      pinentry-gnome
      ripgrep
      sysfsutils
      unzip
      usbutils
      wget
      whois
      yubikey-manager
      zip
    ];
  };
}
