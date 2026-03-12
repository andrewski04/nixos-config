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
    unstable.godot
  ];
}
