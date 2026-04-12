{ pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    qemu
    gnome-boxes
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.users.andrew = {
    extraGroups = [ "libvirtd" ];
  };

}
