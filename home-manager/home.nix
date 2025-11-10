{ config, pkgs, ... }:

let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-25.05";
  });
  vim-airline-themes = pkgs.vimUtils.buildVimPlugin {
    name = "vim-airline-themes";
    src = pkgs.fetchFromGitHub {
      owner = "vim-airline";
      repo = "vim-airline-themes";
      rev = "77aab8c6cf7179ddb8a05741da7e358a86b2c3ab";
      sha256 = "xTgitX/kL8m/zjcxjCe4WWvhKfVPS284GoZjWkWc/gY=";
    };
  };
  inherit (pkgs) lib;
  hostPlatform = pkgs.stdenv.hostPlatform;
  isWindowsHost = if hostPlatform ? isWindows then hostPlatform.isWindows else false;
in
{
  programs.home-manager.enable = true;

  imports = [
    nixvim.homeModules.nixvim
    ./hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "smudge";
  home.homeDirectory = "/home/smudge";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    [
      pkgs.jq # Scripting on top of Hyprland
      pkgs.autojump
      pkgs.bat
      pkgs.direnv
      pkgs.eza
      pkgs.fzf
      pkgs.fd
      pkgs.git
      pkgs.nodejs
      pkgs.rescuetime
      pkgs.ripgrep
      pkgs.rustup
      pkgs.tmux
      pkgs.yarn
      pkgs.hasklig
      pkgs.alacritty
      pkgs.firefox
      pkgs.ludusavi
      pkgs.tiled
      pkgs.discord
      pkgs.obsidian

      pkgs.spirv-tools
      pkgs.vulkan-validation-layers

      (pkgs.wine.override { wineBuild = "wine64"; })

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.wl-clipboard
      pkgs.xclip
    ]
    ++ lib.optionals isWindowsHost [
      pkgs.win32yank
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/smudge/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "eza";
      cat = "bat --paging=never --style=plain";
      du = "ncdu --color dark -rr -x --exclude .git --exclude node_modules";
      vim = "nvim";
      vi = "nvim";
    };
    initExtra = ''
      if type tmux &>/dev/null; then
        if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "alacritty" ]; then
          [ -z "$TMUX"  ] && { exec tmux new-session && exit; }
        fi
      fi
    '';
    bashrcExtra = ''
     eval "$(direnv hook bash)"
    '';
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g mouse on
      set -g status off
      set -ga terminal-overrides ',*256col*:Tc'
      set -g default-terminal "screen-256color"
      set -g set-clipboard on
      set-option -s escape-time 10
      set -ga update-environment " WAYLAND_DISPLAY WAYLAND_SOCKET XDG_RUNTIME_DIR"

      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -n C-S-Left previous-window
      bind -n C-S-Right next-window
    '';
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Core
    globals = {
      # Disable useless providers
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0;
    };
    editorconfig.enable = true;
    clipboard = {
      register = "unnamed,unnamedplus"; # system clipboard
      providers =
        lib.optionalAttrs pkgs.stdenv.isLinux {
          wl-copy.enable = true;
          xclip.enable = true;
        };
    };
    opts = {
      mouse = "a"; # i dare you to call me lazy
      # mousemodel = "extend";
      wildmenu = true;
      wildmode = "list:longest";

      textwidth = 80;
      updatetime = 100;
      timeoutlen = 1000;
      ttimeoutlen = 10;
      autoread = true;
      autowrite = true;
      backspace = "indent,eol,start";
      encoding = "utf8";
      fileencoding = "utf-8";
      fileformats = "unix,dos,mac";
      ignorecase = true;
      smartcase = true; # if uppercase, be case sensitive
      incsearch = true;
      infercase = true;
      laststatus = 2;
      linebreak = true;
      # swapfile = false;
      # hidden = true;
      # undofile = true;
      # scrolloff = 8;
      # cursorline = false;
      # cursorcolumn = false;
      # colorcolumn = "100";

      # show hidden characters
      listchars = "tab:▸\ ,eol:¬,space:.,trail:\!";
      list = false;

      # Gutter
      signcolumn = "yes"; # Keep expanded
      number = true;
      # relativenumber = true;

      # Faster drawing
      lazyredraw = true;
      ttyfast = true;

      # Default filetype options
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      spell = false;
      wrap = false;
    };

    # Options for specific file types
    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "tex"
          "latex"
          "markdown"
          "gitcommit"
        ];
        # Enable spellcheck and show hidden characters
        command = "setlocal spell spelllang=en list";
      }
    ];

    # Theme
    colorschemes.onedark.enable = true;
    plugins.web-devicons.enable = true;

    # GUI
    plugins.telescope = {
      enable = true;
      settings.defaults = {
        layout_config = {
          prompt_position = "top";
          width = 0.95;
          height = 0.95;
        };
        sorting_strategy = "ascending";
        set_env = { COLORTERM = "truecolor"; };
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^tmp/"
          "^log/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        mappings = {
          i = {
            "<C-j>" = {
              __raw = "require('telescope.actions').move_selection_next";
            };
            "<C-k>" = {
              __raw = "require('telescope.actions').move_selection_previous";
            };
          };
        };
      };
    };
    plugins.treesitter.enable = true; # needed for telescope
    keymaps = [
      {
        action = ":Telescope find_files<CR>";
        key = "<C-p>";
        mode = "n";
      }
      {
        action = ":Telescope live_grep<CR>";
        key = "<A-p>";
        mode = "n";
      }
    ];
    plugins.airline.enable = true;
    plugins.airline.settings.powerline_fonts = 1;
    extraConfigVim = ''
      let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " hide the type if it's expected
      let g:airline#extensions#hunks#enabled=0
      let g:airline#extensions#branch#enabled=1
      let g:airline#extensions#tabline#enabled=1
      let g:airline#extensions#tabline#buffer_min_count = 2
      let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

      if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif
      if (has("termguicolors"))
        set termguicolors
      endif
    '';
    extraConfigLua = ''
      local function has_system_provider()
        return vim.fn.executable("wl-copy") == 1
          or vim.fn.executable("xclip") == 1
          or vim.fn.executable("pbcopy") == 1
          or vim.fn.executable("win32yank.exe") == 1
      end
      if vim.env.TMUX and not has_system_provider() then
        local ok, osc52 = pcall(require, "osc52")
        if ok then
          osc52.setup({ trim = true })
          local function copy(lines, _)
            osc52.copy(table.concat(lines, "\n"))
          end
          local function paste()
            local reg = vim.fn.getreg('"', 1, true)
            local regtype = vim.fn.getregtype('"')
            return { reg, regtype }
          end
          vim.g.clipboard = {
            name = "osc52",
            copy = { ["+"] = copy, ["*"] = copy },
            paste = { ["+"] = paste, ["*"] = paste },
          }
        end
      end
    '';

    # LSP & Languages
    lsp = {
      inlayHints.enable = true;
      servers = {
        clangd.enable = true;
        texlab.enable = true; # inria
        lua_ls = {
          enable = true;
          settings.settings.diagnostics.globals = [ "vim" ];
        };
      };
    };
    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    plugins.lspconfig.enable = true; # sane defaults

    # Auto-Trim Whitespace
    plugins.trim = {
      enable = true;
      settings = {
        highlight = true;
        ft_blocklist = [
          "markdown"
          "checkhealth"
          "lspinfo"
          "neo-tree"
        ];
      };
    };

    # Additional plugins
    plugins = {
      # Editor
      startify.enable = true;
      gitgutter.enable = true;
      yanky = {
        enable = true;
        settings.highlight.timer = 300; # default 500
      };
      goyo.enable = true;
      # limelight.enable = true;
      tmux-navigator.enable = true;

      # Files/Git/Search
      fugitive.enable = true;
      neo-tree.enable = true;
      # fzf-lua.enable = true;

      # Linting/Normalizing
      # ale.enable = true;

      # Integrations
      # webapi.enable = true;
      # gist.enable = true;
      # copilot-vim.enable = true;

      # Languages/Syntax
      nix.enable = true;
      # ruby.enable = true;
      # rails.enable = true;
      endwise.enable = true;
      vim-surround.enable = true;
      # rake.enable = true;
      # rust.enable = true;
      # javascript.enable = true;
      # typescript.enable = true;
      # jsx-pretty.enable = true;
      # vim-misc.enable = true;
      # vim-lua-ftplugin.enable = true;

      # Markdown
      # markdown.enable = true;
      # vim-markdown-toc.enable = true;
      markdown-preview.enable = true;

      # HTML
      # bracey.enable = true;

      # VS Code Language Servers
      # coc-nvim.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-airline-themes
      nvim-osc52
    ];
  };

  # Enable autojump
  programs.autojump.enable = true;
  programs.autojump.enableBashIntegration = true;

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "Adwaita-dark";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
