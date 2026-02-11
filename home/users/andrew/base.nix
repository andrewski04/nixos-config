{ pkgs, ... }:

{
  # Pure CLI tools only
  home.packages = with pkgs; [
    fastfetch
    htop
    nil
    nixfmt
    opentofu
    sops
    age
    discord
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Andrew";
      user.email = "andrew@housermail.com";
    };
  };

  programs.vim.enable = true;

  home.stateVersion = "24.11";
}
