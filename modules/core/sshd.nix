{ ... }:

{
  networking.firewall.allowedTCPPorts = [
    22
  ];
  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  # pub keys
  users.users.andrew.openssh.authorizedKeys.keys = [
    # nixos laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWAbnpdCyp/WuUgcU3MEOXMiOIPXUxM9qgmQjj923cV andrew@nixos-laptop"
    # hsrnet-nix
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFthL1dW729BToFlRLilTBGV0s5m5F51RF8NDmeBc1+J andrew@hsrnet-nix"
    # desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL06UH/SIFWTHpFe9pr6ZlGnDw6PKJ6SAD+3gNumsJhR andrew@desktop"
  ];

}
