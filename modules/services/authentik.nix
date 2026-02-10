{ config, pkgs, ... }:

{
  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets.authenik_env.path;
    settings = {
      email = {
        host = "smtp.hsr.wtf";
        port = 587;
        username = "authentik@hsr.wtf";
        use_tls = true;
        use_ssl = false;
        from = "authentik@hsr.wtf";
      };
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };

  services.opentofu.configurations.authentik = {
    source = ../../terraform/authentik;
    environmentFiles = [ config.sops.secrets.authenik_env.path ];
    vars = {
      # The environment file exports AUTHENTIK_BOOTSTRAP_TOKEN
      # We map it to the terraform variable authentik_api_token
      authentik_api_token = "$AUTHENTIK_BOOTSTRAP_TOKEN";
    };
  };

  # Ensure Authentik is running before applying terraform
  systemd.services.opentofu-authentik = {
    wants = [ "authentik.service" ];
    after = [ "authentik.service" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
    preStart = ''
      # Wait for Authentik to be ready
      echo "Waiting for Authentik to allow connections..."
      until ${pkgs.curl}/bin/curl --fail --silent --insecure --max-time 5 https://127.0.0.1:9443/-/health/live/; do
        echo "Authentik not ready. Retrying in 2 seconds..."
        sleep 2
      done
      echo "Authentik is ready!"
    '';
  };

}
