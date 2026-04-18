{
  config,
  pkgs,
  inputs,
  ...
}:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = [
    (unstable.ollama.override {
      acceleration = "cuda";
    })
    unstable.open-webui
    unstable.ffmpeg
  ];

  services.ollama = {
    enable = true;
    package = unstable.ollama-cuda;
    # preload models, see https://ollama.com/library
    #loadModels = [
    #  "gemma4:latest"
    #  "gemma4:31b"
    #];
  };

  services.open-webui.enable = true;
  services.open-webui.environment = {
    FRONTEND_BUILD_DIR = "${config.services.open-webui.stateDir}/build";
    DATA_DIR = "${config.services.open-webui.stateDir}/data";
    STATIC_DIR = "${config.services.open-webui.stateDir}/static";
  };

}
