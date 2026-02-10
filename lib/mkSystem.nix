inputs:
{
  system ? "x86_64-linux",
  hostname,
  user ? "andrew",
  userConfig ? ../home/users/andrew/desktop.nix,
  extraModules ? [ ],
}:
let
  inherit (inputs) nixpkgs home-manager;
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ../hosts/${hostname}
    ../modules/core
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.${user} = import userConfig;
    }
  ]
  ++ extraModules;
}
