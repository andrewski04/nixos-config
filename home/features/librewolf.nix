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
        "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Google";
        "browser.policies.runOncePerModification.removeSearchEngines" = [ "" ];
      };
      search = {
        default = "google";
        privateDefault = "google";
        force = true;
      };
      # Using NUR packages (via overlay defined in flake.nix)
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        proton-pass
      ];
    };
    policies = {
      force = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      ExtensionSettings = {
        default_area = "navbar";
      };
    };
  };

  xdg.mime.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
}
