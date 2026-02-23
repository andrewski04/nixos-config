# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-4f6640dc-82c0-4052-bda3-24857e2d56f0".device =
    "/dev/disk/by-uuid/4f6640dc-82c0-4052-bda3-24857e2d56f0";

  networking.hostName = "desktop";

  # waydroid
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [
    pkgs.waydroid-helper
    pkgs.wl-clipboard
  ];
  networking.firewall.trustedInterfaces = [ "waydroid0" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  system.stateVersion = "25.11"; # Did you read the comment?

}
