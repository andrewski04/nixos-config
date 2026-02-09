{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.vscode = {
    enable = true;

    package = unstable.vscode;

    # Extensions
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      esbenp.prettier-vscode
    ];

    # Settings.json
    profiles.default.userSettings = {
      "editor.formatOnSave" = true;
      "files.autoSave" = "onFocusChange";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "git.autofetch" = true;
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
    };
  };
}
