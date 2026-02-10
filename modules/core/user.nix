{ pkgs, ... }:
{
  users.users.andrew = {
    isNormalUser = true;
    description = "andrew";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };
}
