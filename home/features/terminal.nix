{
  pkgs,
  stdenv,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      cursor-style = "block";
      shell-integration-features = true;
      theme = "catppuccin-mocha";
    };
    themes = {
      catppuccin-mocha = {
        background = "1e1e2e";
        cursor-color = "f5e0dc";
        foreground = "cdd6f4";
        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#bac2de"
          "8=#585b70"
          "9=#f38ba8"
          "10=#a6e3a1"
          "11=#f9e2af"
          "12=#89b4fa"
          "13=#f5c2e7"
          "14=#94e2d5"
          "15=#a6adc8"
        ];
        selection-background = "353749";
        selection-foreground = "cdd6f4";
      };
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
      set-option -g default-terminal "tmux-256color"
      set-option -sa terminal-features ',xterm-256color:RGB'

      # window indexing
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      #open panes in curr dir
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      set-option -g focus-events on
      set-option -sg escape-time 10
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

      debugMode = {
        enable = false;
        level = 16;
        logFile = "/tmp/nvim.log";
      };

      opts.expandtab = true;

      spellcheck = {
        enable = false;
        programmingWordlist.enable = false;
      };

      lsp = {
        enable = true;

        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true; # Shows a VSCode-style lightbulb for available code actions
        lspsaga.enable = false;
        trouble.enable = true; # Provides a bottom panel for project-wide errors/diagnostics
        lspSignature.enable = true; # Shows function parameters automatically typing
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
        presets.harper.enable = false;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        go.enable = true;
        python.enable = true;
        markdown.enable = true;
        bash.enable = true;
        json.enable = true;
        lua.enable = true;
        css.enable = true;
        html.enable = true;
        typescript.enable = true;
        typst.enable = true;
        rust = {
          enable = true;
          extensions.crates-nvim.enable = true;
        };
        toml.enable = true;
        xml.enable = true;
      };

      visuals = {
        nvim-scrollbar.enable = true; # Adds a visual scrollbar to the right margin
        nvim-web-devicons.enable = true; # Adds VSCode-like file icons to the file tree and tabs
        nvim-cursorline.enable = true; # Highlights the line your cursor is currently on
        cinnamon-nvim.enable = true; # Provides smooth scrolling
        fidget-nvim.enable = true; # Shows LSP loading status in the bottom right corner

        highlight-undo.enable = true;
        blink-indent.enable = true;
        indent-blankline.enable = true; # Renders vertical lines to indicate indentation scope

        cellular-automaton.enable = false;
      };

      statusline = {
        lualine = {
          enable = true; # Replaces standard statusline with an informative, styled bar
          #theme = "catppuccin";
        };
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      autopairs.nvim-autopairs.enable = true; # Automatically closes brackets, quotes, and parentheses

      autocomplete = {
        nvim-cmp.enable = true; # Standard, reliable completion engine (similar to VSCode IntelliSense)
        blink-cmp.enable = false;
      };

      snippets.luasnip.enable = true; # Required backend for expanding autocomplete snippets

      filetree = {
        neo-tree = {
          enable = true; # File explorer sidebar (usually toggled via a mapped key)
        };
      };

      tabline = {
        nvimBufferline.enable = true; # Renders open buffers as VSCode-style tabs at the top
      };

      treesitter.context.enable = true; # Keeps the current function/class signature pinned at the top when scrolling

      binds = {
        whichKey.enable = true; # Shows a popup with available keybinds when you press a prefix key
        cheatsheet.enable = true;
      };

      telescope.enable = true; # Powerful fuzzy finder (Ctrl+P equivalent for files, text, and commands)

      git = {
        enable = true;
        gitsigns.enable = true; # Shows git diff markers (added/modified/deleted) in the left gutter
        gitsigns.codeActions.enable = false;
        neogit.enable = false; # Complex Magit clone; Telescope and Gitsigns are usually enough for starters
      };

      minimap = {
        minimap-vim.enable = false;
        codewindow.enable = false; # VSCode-style minimap. Often disabled in Neovim to save screen space
      };

      dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true; # Provides a welcome screen with quick links when opening Neovim without a file
      };

      notify = {
        nvim-notify.enable = true; # Replaces standard text messages with floating notification bubbles
      };

      projects = {
        project-nvim.enable = true; # Automatically manages VSCode-style workspace roots based on git directories
      };

      utility = {
        ccc.enable = false;
        vim-wakatime.enable = false;
        diffview-nvim.enable = true; # Dedicated interface for viewing git diffs
        yanky-nvim.enable = false;
        qmk-nvim.enable = false;
        icon-picker.enable = false;
        surround.enable = true; # Allows quick changing/adding of surrounding quotes and brackets
        leetcode-nvim.enable = false;
        multicursors.enable = true; # Enables VSCode-style multi-cursor editing
        smart-splits.enable = true; # Easier navigation between split window panes
        undotree.enable = true; # Visualizes local file history as a tree
        nvim-biscuits.enable = false;
        grug-far-nvim.enable = true; # Provides project-wide find and replace functionality

        motion = {
          hop.enable = true; # Jump quickly to any visible word on the screen
          leap.enable = true;
          precognition.enable = false;
        };
        images = {
          image-nvim.enable = false;
          img-clip.enable = false;
        };
      };

      notes = {
        neorg.enable = false;
        orgmode.enable = false;
        mind-nvim.enable = false;
        todo-comments.enable = true; # Highlights TODO, FIXME, NOTE comments in code
      };

      terminal = {
        toggleterm = {
          enable = true; # Replicates VSCode's integrated terminal panel (floating or split)
          lazygit.enable = true; # Integrates the lazygit CLI tool into a floating terminal
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true; # Replaces the command line and popup menus with modern UI elements
        colorizer.enable = true; # Previews hex colors (e.g., #FFFFFF) directly in the editor
        modes-nvim.enable = false;
        illuminate.enable = true; # Automatically highlights other uses of the word under your cursor
        breadcrumbs = {
          enable = true; # VSCode-style file path and symbol hierarchy at the top of the editor
          navbuddy.enable = false;
        };
        smartcolumn = {
          enable = true; # Renders a vertical line to help enforce line length limits
          setupOpts.custom_colorcolumn = {
            nix = "110";
            ruby = "120";
            java = "130";
            go = [
              "90"
              "130"
            ];
          };
        };
        fastaction.enable = true;
      };

      assistant = {
        chatgpt.enable = false;
        copilot = {
          enable = false;
          cmp.enable = false;
        };
        codecompanion-nvim.enable = false;
        avante-nvim.enable = false;
      };

      session = {
        nvim-session-manager.enable = false;
      };

      gestures = {
        gesture-nvim.enable = false;
      };

      comments = {
        comment-nvim.enable = true;
      };

      presence = {
        neocord.enable = false;
      };
    };
  };
}
