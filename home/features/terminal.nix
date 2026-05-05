{
  pkgs,
  stdenv,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      cursor-style = "block";
      shell-integration-features = true;
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      catppuccin
      yank
    ];
    mouse = true;
    prefix = "C-Space";
    extraConfig = ''
      # color options
      set-option -sa terminal-overrides ",xterm*:Tc"

      # window indexing
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      #open panes in curr dir
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };

  #programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  #  vimAlias = true;
  #  viAlias = true;
  #  plugins = with pkgs.vimPlugins; [
  #    vim-tmux-navigator
  #    catppuccin-nvim
  #  ];
  #};

  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;
      languages = {
        enableLSP = true;
        enableTreesitter = true;
      };
      filetree.neo-tree.enable = true;
    };

  };

}
