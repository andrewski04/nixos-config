{ config, pkgs, ... }:
{

  services.nginx = {
    # Upstream where your authentik server is hosted.
    upstreams.authentik = {
      servers."127.0.0.1:9443" = { };
      extraConfig = "keepalive 10;";
    };

    # Upgrade WebSocket if requested, otherwise use keepalive
    commonHttpConfig = ''
      map $http_upgrade $connection_upgrade_keepalive {
        default upgrade;
        ""      "";
      }
    '';

    virtualHosts."sso.hsr.wtf" = {
      forceSSL = true;
      enableACME = true;
      locations."/media/" = {
        alias = "${../../../media}/";
      };
      locations."/" = {
        proxyPass = "https://authentik";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade_keepalive;

          # Increase buffer size for large headers
          proxy_buffers 8 16k;
          proxy_buffer_size 32k;
        '';
      };
    };
  };

}
