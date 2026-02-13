{ pkgs, inputs, ... }:
{
  imports = [
    ./user.nix
    ./sops.nix
  ];

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];
  # Common System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    git
    xdg-utils
    dnsutils
    age
    uv
  ];

  programs.nix-ld.enable = true;

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  networking.extraHosts = ''
    45.79.202.195 hsrnet-nix
  '';

  # Locale & Time
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Network Manager
  networking.networkmanager.enable = true;
}
