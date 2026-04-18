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
      # ksp (luna multiplayer)
      listen 8800 udp;
      proxy_pass 10.0.5.200:8800;
    }
  '';

  networking.firewall.allowedUDPPorts = [
    8800
    #5520
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
