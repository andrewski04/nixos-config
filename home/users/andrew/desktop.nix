{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  # configured
  imports = [
    ./base.nix
    ../../features/vscode.nix # Add GUI tools
    ../../features/librewolf.nix
    ../../features/ghostty.nix
  ];

  home.packages = with pkgs; [
    unstable.antigravity
    gnome-tweaks
    nodejs_24
    python315
    chromium
    discord
    steam
  ];

  services.netbird.clients.wt0 = {
 login = {
      enable = true;

      # Path to a file containing the setup key for your peer
      # NOTE: if your setup key is reusable, make sure it is not copied to the Nix store.
      setupKeyFile = "/path/to/your/setup-key";
    };

  }

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      accent-color = "red";
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri-dark = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "librewolf.desktop"
        "com.mitchellh.ghostty.desktop"
        "code.desktop"
        "antigravity.desktop"
      ];
    };

    # keybinds
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "ghostty";
      name = "open-terminal";
    };
  };

  # Any desktop-specific GTK themes or fonts can go here
  gtk.enable = true;
}
