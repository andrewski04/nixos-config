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
    nil
    nixfmt
    gnome-tweaks
    nodejs_24
    python315
    chromium
  ];

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
        "ghostty.desktop"
        "code.desktop"
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
