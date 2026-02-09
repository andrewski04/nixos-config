{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.librewolf = {
    enable = true;
    package = unstable.librewolf;
    policies = {
      ExtensionSettings = {
        default_area = "navbar";
      };
    };
    profiles.default = {
      isDefault = true;
      settings = {
        "webgl.disabled" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "network.cookie.lifetimePolicy" = 0;
        "general.useragent.compatMode.firefox" = true;
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
      };
      search = {
        default = "google";
        force = true;
      };
      # Using NUR packages (via overlay defined in flake.nix)
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        proton-pass
      ];
    };
  };

  # Set default app associations here too if you like
  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
}
