{ config, pkgs, ... }:
{
  security.acme.defaults.email = "admin@hsr.wtf";
  security.acme.acceptTerms = true;
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.nginx.streamConfig = ''
    server {
      # minecraft
      listen 25565 udp;
      proxy_pass 10.0.5.50:25565;
    }
    server {
      # hytale
      listen 5520 udp;
      proxy_pass 10.0.5.200:5520;
    }
  '';

  networking.firewall.allowedUDPPorts = [
    #25565
    #5520
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
