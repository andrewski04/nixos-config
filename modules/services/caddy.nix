{ config, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."nix.hsr.wtf".extraConfig = ''
      respond "Hello, world!"
    '';

  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
