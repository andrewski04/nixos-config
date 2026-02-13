{ config, lib, ... }:

let
  domain = "hsr.wtf";
  netbirdDomain = "vpn.${domain}";
  ssoDomain = "sso.${domain}";
  # clientId will be provided by setup.env at runtime

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
        AUTH_AUTHORITY = "https://${ssoDomain}/application/o/netbird/";
        # AUTH_CLIENT_ID and AUTH_AUDIENCE managed via EnvironmentFile
      };
    };

    management = {
      enable = true;
      enableNginx = true;
      domain = netbirdDomain;
      turnDomain = netbirdDomain;
      disableSingleAccountMode = true;
      disableAnonymousMetrics = true;
      oidcConfigEndpoint = "https://${ssoDomain}/application/o/netbird/.well-known/openid-configuration";

      settings = {
        Signal.URI = "${netbirdDomain}:443";

        HttpConfig.AuthAudience = "netbird"; # Placeholder, overridden by ENV
        IdpManagerConfig.ClientConfig.ClientID = "netbird"; # Placeholder
        DeviceAuthorizationFlow.ProviderConfig = {
          Audience = "netbird"; # Placeholder
          ClientID = "netbird"; # Placeholder
        };
        PKCEAuthorizationFlow.ProviderConfig = {
          Audience = "netbird"; # Placeholder
          ClientID = "netbird"; # Placeholder
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

  # Make the env available to the systemd service
  systemd.services.netbird-management = {
    serviceConfig.EnvironmentFile = "/var/lib/netbird/setup.env";
    wants = [ "authentik-terraform-apply.service" ];
    after = [ "authentik-terraform-apply.service" ];
  };

  systemd.services.netbird-dashboard = {
    serviceConfig.EnvironmentFile = "/var/lib/netbird/setup.env";
    wants = [ "authentik-terraform-apply.service" ];
    after = [ "authentik-terraform-apply.service" ];
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
