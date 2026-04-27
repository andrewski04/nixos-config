{
  pkgs,
  config,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    netbird-ui
    steam
    bottles
    libimobiledevice
    usbmuxd2
    moonlight-qt
    jdk
    readest
    protonup-qt
    readest
    gcc
    ckan
    cmake
    gnumake
    prismlauncher
    jetbrains.clion
  ];

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  hardware.steam-hardware.enable = true;

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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
