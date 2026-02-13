{ config, lib, ... }:

let
  domain = "hsr.wtf";
  netbirdDomain = "vpn.${domain}";
in
{
  services.netbird.server = {
    enable = true;
    enableNginx = true;
    domain = netbirdDomain;

    coturn = {
      enable = true;
      domain = netbirdDomain;
      passwordFile = config.sops.secrets."netbird/turn_password".path;
    };

    signal = {
      enable = true;
      enableNginx = true;
      domain = netbirdDomain;
    };

    dashboard = {
      enable = true;
      enableNginx = true;
      domain = netbirdDomain;
      settings = {
        AUTH_AUTHORITY = "https://sso.hsr.wtf/application/o/netbird/";
        AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
        AUTH_AUDIENCE = "netbird";
        AUTH_CLIENT_ID = "netbird";
      };

    };

    management = {
      enable = true;
      enableNginx = true;
      domain = netbirdDomain;
      turnDomain = netbirdDomain;
      disableSingleAccountMode = false;
      singleAccountModeDomain = "${netbirdDomain}";
      disableAnonymousMetrics = true;
      oidcConfigEndpoint = "https://sso.hsr.wtf/application/o/netbird/.well-known/openid-configuration";

      settings = {
        Signal.URI = "${netbirdDomain}:443";

        HttpConfig = {
          AuthAudience = "netbird";
          AuthUserIDClaim = "sub";
        };

        IdpManagerConfig = {
          ManagerType = "authentik";
          ClientConfig = {
            Issuer = "https://sso.hsr.wtf/application/o/netbird/";
            ClientID = "netbird";
            TokenEndpoint = "https://sso.hsr.wtf/application/o/token/";
            ClientSecret = "";
          };
          ExtraConfig = {
            Password._secret = config.sops.secrets."netbird/authentik_password".path;
            Username = "Netbird";
          };
        };

        PKCEAuthorizationFlow.ProviderConfig = {
          Audience = "netbird";
          ClientID = "netbird";
          ClientSecret = "";
          AuthorizationEndpoint = "https://sso.hsr.wtf/application/o/authorize/";
          TokenEndpoint = "https://sso.hsr.wtf/application/o/token/";
          RedirectURLs = [ "http://localhost:53000" ];
        };

        TURNConfig = {
          Secret._secret = config.sops.secrets."netbird/turn_password".path;
          CredentialsTTL = "12h";
          TimeBasedCredentials = false;
          Turns = [
            {
              Password._secret = config.sops.secrets."netbird/turn_password".path;
              Proto = "udp";
              URI = "turn:${netbirdDomain}:3478";
              Username = "netbird";
            }
          ];
        };
        Relay = {
          Addresses = [ "rels://${netbirdDomain}:33080" ];
          CredentialsTTL = "24h";
          Secret._secret = config.sops.secrets."netbird/relay_secret".path;
        };
        DataStoreEncryptionKey._secret = config.sops.secrets."netbird/data_store_encryption_key".path;
      };
    };
  };

  # Override ACME settings to get a cert
  services.nginx.virtualHosts = lib.mkMerge [
    {
      "${netbirdDomain}" = {
        enableACME = true;
        forceSSL = true;
      };
    }
  ];

  # Run the Netbird relay with TLS to allow relaying over TCP
  virtualisation.oci-containers.containers.netbird-relay = {
    image = "netbirdio/relay:latest";
    ports = [
      "33080:33080"
    ];
    volumes = [
      "/var/lib/acme/${netbirdDomain}/:/certs:ro"
    ];
    environment = {
      NB_LOG_LEVEL = "info";
      NB_LISTEN_ADDRESS = ":33080";
      NB_EXPOSED_ADDRESS = "rels://${netbirdDomain}:33080";
      NB_TLS_CERT_FILE = "/certs/fullchain.pem";
      NB_TLS_KEY_FILE = "/certs/key.pem";
    };
    environmentFiles = [
      config.sops.secrets."netbird/relay_secret_container".path
    ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    3478
    10000
    33080
  ];
  networking.firewall.allowedUDPPorts = [
    3478
    5349
    33080
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 40000;
      to = 40050;
    }
  ]; # TURN ports

  systemd.tmpfiles.rules = [
    "d /var/lib/netbird 0700 netbird netbird -"
  ];
}
