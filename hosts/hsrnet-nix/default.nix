{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/core/sshd.nix
    ../../modules/services/nginx.nix
    ../../modules/services/authentik.nix
  ];
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."authenik_env" = { };

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

  environment.systemPackages = with pkgs; [
    vim
    wget
    sops
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    #ssh
    22
  ];
  #networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
