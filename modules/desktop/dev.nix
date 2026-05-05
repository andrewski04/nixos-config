{
  pkgs,
  config,
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
  environment.systemPackages = with pkgs; [
    unstable.gemini-cli
    cmake
    gnumake
    go
    gcc
    jdk
    pkg-config
    github-desktop
    direnv
    gh
  ];
}
