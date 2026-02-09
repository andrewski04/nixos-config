{ pkgs, ... }:
{
  # Common System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    git
    xdg-utils
  ];

  programs.nix-ld.enable = true;

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Locale & Time
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Network Manager
  networking.networkmanager.enable = true;
}
