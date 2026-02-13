{ pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    netbird-ui
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.netbird.enable = true;
  services.resolved.enable = true;

  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    epiphany
  ];

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  programs.xwayland.enable = true;

  services.printing.enable = false;

  security.sudo.wheelNeedsPassword = false;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
