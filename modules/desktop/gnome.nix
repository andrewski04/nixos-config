{ pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    netbird-ui
    steam
    bottles
    uxplay
    libimobiledevice
    usbmuxd2
  ];

  services.flatpak.enable = true;

  # needed for noisetorch to have microphone access
  # programs.noisetorch.enable = true;

  # airplay mdns
  #services.usbmuxd.enable = true;
  #services.avahi = {
  #  nssmdns4 = true;
  #  enable = true;
  #  publish = {
  #    enable = true;
  #    userServices = true;
  #    domain = true;
  #  };
  #};
  ##airplay ports not found :(
  #networking.firewall.enable = false;

  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # Network Manager
  networking.networkmanager.enable = true;

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
