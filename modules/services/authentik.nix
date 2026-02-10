{ config, pkgs, ... }:
{
  services.authentik = {
    enable = false;
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
}
