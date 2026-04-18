{ pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    uxplay
  ];

  services.flatpak.enable = true;

  #airplay mdns
  services.usbmuxd.enable = true;
  services.avahi = {
    nssmdns4 = true;
    enable = true;
    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };
  #airplay ports not found :(
  networking.firewall.enable = false;
}
