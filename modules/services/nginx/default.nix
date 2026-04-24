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
    upstream mc_server {
      server 10.0.5.50:25565;
    }

    server {
     # minecraft
     listen 25565;
     proxy_pass mc_server;
    }
  '';

  # jellyfin reverse proxy
  services.nginx = {
    virtualHosts."jellyfin.hsr.wtf" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;

      extraConfig = ''
        client_max_body_size 20M;
        ssl_protocols TLSv1.3 TLSv1.2;
        set $jellyfin 10.0.5.74;

        # Security Headers
        add_header X-Content-Type-Options "nosniff";
        add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;
        add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; font-src 'self'";
      '';

      locations."/" = {
        proxyPass = "http://$jellyfin:80";
        extraConfig = ''
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_buffering off;
        '';
      };

      locations."/socket" = {
        proxyPass = "http://$jellyfin:80";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
        '';
      };
    };
  };

  networking.firewall.allowedUDPPorts = [
    #8800
    #5520
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
    25565
  ];
}
