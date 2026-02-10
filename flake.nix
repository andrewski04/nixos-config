{
  description = "Andrewski's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nur,
      sops-nix,
      authentik-nix,
      ...
    }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix inputs;
    in
    {
      nixosConfigurations = {

        #=== HOST 1: The Desktop VM ===
        nixos-vm = mkSystem {
          hostname = "nixos-vm";
          extraModules = [ ./modules/desktop/gnome.nix ];
        };

        #=== HOST 2: nixos-laptop ===
        nixos-laptop = mkSystem {
          hostname = "nixos-laptop";
          extraModules = [ ./modules/desktop/gnome.nix ];
        };

        #=== HOST 3: nixos-desktop ===
        nixos-desktop = mkSystem {
          hostname = "nixos-desktop";
          extraModules = [ ./modules/desktop/gnome.nix ];
        };

        #=== HOST 4: hsrnet-nix ===
        hsrnet-nix = mkSystem {
          hostname = "hsrnet-nix";
          userConfig = ./home/users/andrew/base.nix;
          extraModules = [
            ./modules/core/sshd.nix
            ./modules/services/nginx.nix
            ./modules/services/authentik.nix
            ./modules/services/opentofu.nix
            authentik-nix.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };

      };

    };
}
