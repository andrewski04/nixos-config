{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/core/sshd.nix
    ../../modules/services/caddy.nix
    ../../modules/services/authentik.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/authentik.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/andrew/.config/sops/age/keys.txt";
    secrets.authentik-env = { };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  networking.hostName = "hsrnet-nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      git
    ];
  };

  # environment.systemPackages = with pkgs; [
  #   vim
  #   wget
  # ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    #ssh
    22
  ];
  #networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
