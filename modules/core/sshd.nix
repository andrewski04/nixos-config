{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };

    # pub keys
    users.users.andrew.openssh.authorizedKeys.keys = [
      # windows desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpWekWY3Yov8gqTlu7U5h0hKXpA5nyUcdGs4CNsFdkx andrew@DESKTOP-BCA9DQQ"
      # nixos laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWAbnpdCyp/WuUgcU3MEOXMiOIPXUxM9qgmQjj923cV andrew@nixos-laptop"
    ];
  };
}
