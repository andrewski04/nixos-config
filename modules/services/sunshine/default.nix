{
  config,
  lib,
  pkgs,
  ...
}:
{
  # fix screen wakeup: `loginctl unlock-sessions`
  users.users.andrew.extraGroups = [
    "video"
    "input"
  ];
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

}
