{pkgs, ...}: {
  # Pure CLI tools only
  home.packages = with pkgs; [
    fastfetch
    htop
    nil
    nixfmt
    opentofu
    sops
    age
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Andrew";
      user.email = "andrew@housermail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.vim.enable = true;

  home.stateVersion = "24.11";
}
