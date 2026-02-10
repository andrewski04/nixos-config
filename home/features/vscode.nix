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
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.remote-explorer
    ];

    # Settings.json
    profiles.default.userSettings = {
      "workbench.externalBrowser" = "librewolf";
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
