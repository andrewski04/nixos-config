{ pkgs, ... }:

{
  # Pure CLI tools only
  home.packages = with pkgs; [
    fastfetch
    htop
  ];

  programs.git = {
    enable = true;
    settings.user.name = "Andrew";
  };
  
  programs.vim.enable = true;

  home.stateVersion = "24.11";
}