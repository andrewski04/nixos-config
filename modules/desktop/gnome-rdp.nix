{ pkgs, config, ... }:
{
  # Enable the GNOME RDP components
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure the service starts automatically at boot so the settings panel appears
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  # Open the default RDP port (3389)
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Disable autologin to avoid session conflicts
  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;

  # Disable systemd targets for sleep and hibernation
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
