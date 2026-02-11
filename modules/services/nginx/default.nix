{ config, pkgs, ... }:
{
  security.acme.defaults.email = "admin@hsr.wtf";
  security.acme.acceptTerms = true;
  services.nginx = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
