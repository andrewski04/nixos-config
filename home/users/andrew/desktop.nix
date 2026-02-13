{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  autostartPrograms = [
    pkgs.netbird-ui
  ];
in
{
  # configured
  imports = [
    ./base.nix
    ../../features/vscode.nix # Add GUI tools
    ../../features/librewolf.nix
    ../../features/ghostty.nix
  ];

  # gross autostart workaround
  home.file = builtins.listToAttrs (
    map (pkg: {
      name = ".config/autostart/" + pkg.pname + ".desktop";
      value =
        if pkg ? desktopItem then
          {
            text = pkg.desktopItem.text;
          }
        else
          {
            source = (pkg + "/share/applications/" + pkg.pname + ".desktop");
          };
    }) autostartPrograms
  );

  home.packages = with pkgs; [
    unstable.antigravity
    gnome-tweaks
    nodejs_24
    python315
    chromium
    discord
    steam
    gnomeExtensions.appindicator
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
    "org/gnome/shell" = {
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
  };

  # Any desktop-specific GTK themes or fonts can go here
  gtk.enable = true;
}
