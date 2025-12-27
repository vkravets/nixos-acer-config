{
  config,
  pkgs,
  inputs,
  ...
}:

{

  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "easynix";
  home.homeDirectory = "/home/easynix";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Gnome stuff
    gnome-tweaks

    # Gnome Extensions
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    #gnomeExtensions.pop-shell
    #gnomeExtensions.clipboard-indicator
    gnomeExtensions.status-area-horizontal-spacing
    gnomeExtensions.random-wallpaper
    gnomeExtensions.gnome-40-ui-improvements
    gnomeExtensions.lockscreen-extension
    gnomeExtensions.no-overview
    gnomeExtensions.vicinae

    # Gnome browser connector
    gnome-browser-connector

    # Shell tools
    grc
    eza

    # Dev tools
    gnumake
    cmake
    gcc
    autoconf

    # LazyVim
    lazygit
    fd
    ripgrep
    tree-sitter
    nil
    nixfmt-rfc-style
    rustc
    cargo
    wl-clipboard
    marksman
    statix

    # DEV
    jdk21_headless
    maven
    lua

    # Use LTS version, need for installation of some plugins
    nodejs
    python312
    #python312Packages.ruff-lsp
    python312Packages.pynvim
    uv

    # IDE
    # jetbrains-toolbox
    # jetbrains.jdk
    vscode
    vscode-extensions.ms-python.python
    vscode-extensions.ms-python.debugpy
    vscode-extensions.ms-python.pylint
    vscode-extensions.ms-python.vscode-pylance
    vscode-extensions.ms-pyright.pyright
    vscode-extensions.ms-python.black-formatter
    vscode-extensions.anweber.vscode-httpyac
    vscode-extensions.humao.rest-client
    vscode-extensions.oracle.oracle-java
    vscode-extensions.vscjava.vscode-maven
    vscode-extensions.vscjava.vscode-gradle
    vscode-extensions.platformio.platformio-vscode-ide
    vscode-extensions.zainchen.json
    # vscode-extensions.zaaack.markdown-editor
    vscode-extensions.yzhang.markdown-all-in-one
    vscode-extensions.ndonfris.fish-lsp
    vscode-extensions.bmalehorn.vscode-fish

    # Browser
    google-chrome

    # Remote play
    moonlight-qt

    # Messanger
    signal-desktop

    nwjs
    nwjs-ffmpeg-prebuilt
    vlc
  ];

  # home.pointerCursor = {
  #   name = "Capitaine Cursors White";
  #   package = pkgs.capitaine-cursors-themed;
  #   size = 30;
  #   x11.enable = true;
  #   gtk.enable = true;
  # };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

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
    #
    #

    # Gnome Extension Random Wallpaper manual install (in repo outdated version)
    #".local/share/gnome-shell/extensions/randomwallpaper@iflow.space".source = pkgs.fetchFromGitHub
    #  {
    #    owner = "ifl0w";
    #    repo = "RandomWallpaperGnome3";
    #    rev = "v2.7.4";
    #    hash = "sha256-a/l8MzoVKAFsd8YDSVZOC2i6ZyWiI8mzNQv5o/gqxi0=";
    #  } + "/randomwallpaper@iflow.space";

    # Gnome Extensions Cntrol Blur Effect on Lock Screen
    #".local/share/gnome-shell/extensions/ControlBlurEffectOnLockScreen@pratap.fastmail.fm".source = builtins.fetchTarball {
    #  url = "https://github.com/PRATAP-KUMAR/control-blur-effect-on-lock-screen/archive/53b17ccf60dedd815be4657d6e3655d838a984df.tar.gz";
    #  sha256 = "09pg860lh05z15pwajk8ldzjj0hz206rd092b6qp2yir73y8yk93";
    #};

    ##### LazyVim ####
    "${config.xdg.configHome}/lazyvim/lua/config".source =
      pkgs.fetchFromGitHub {
        owner = "LazyVim";
        repo = "starter";
        rev = "92b2689e6f11004e65376e84912e61b9e6c58827";
        hash = "sha256-gE2tRpglA0SxxjGN+uKwkwdR5YurvjVGf8SRKkW0E1U=";
      }
      + "/lua/config";

    "${config.xdg.configHome}/lazyvim/lua/plugins/extra-plugins.lua".text = ''
      -- stylua: ignore

      -- every spec file under config.plugins will be loaded automatically by lazy.nvim
      --
      -- In your plugin files, you can:
      -- * add extra plugins
      -- * disable/enabled LazyVim plugins
      -- * override the configuration of LazyVim plugins
      return {
        {
          "lambdalisue/suda.vim",
          cmd = {"SudaRead", "SudaWrite"},
        },

        {
          "gbprod/cutlass.nvim",
          config = function()
            require("cutlass").setup({
                exclude = { "ns", "nS" },
            })
          end
        },

        -- add symbols-outline
        {
          "simrat39/symbols-outline.nvim",
          cmd = "SymbolsOutline",
          keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
          config = true,
        },

        {
          "nvim-telescope/telescope.nvim",
          keys = {
            -- add a keymap to browse plugin files
            -- stylua: ignore
            {
              "<leader>fp",
              function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
              desc = "Find Plugin File",
            },
          },
          -- change some options
          -- opts = {
          --  defaults = {
          --    layout_strategy = "horizontal",
          --    layout_config = { prompt_position = "top" },
          --    sorting_strategy = "ascending",
          --    winblend = 0,
          --  },
          --},
        },

        -- add more treesitter parsers
        {
          "nvim-treesitter/nvim-treesitter",
          opts = {
            ensure_installed = {
              "bash",
              "vimdoc",
              "html",
              "javascript",
              "json",
              "lua",
              "markdown",
              "markdown_inline",
              "python",
              "query",
              "regex",
              "vim",
              "yaml",
              "nix"
            },
          },
        },

        {
          "mason-org/mason.nvim",
          opts = {
            ensure_installed = {
              "stylua",
              "shellcheck",
              "shfmt",
              "flake8",
            },
          },
        },

        -- Use <tab> for completion and snippets (supertab)
        -- first: disable default <tab> and <s-tab> behavior in LuaSnip
        {
          "L3MON4D3/LuaSnip",
          keys = function()
            return {}
          end,
        },
        -- then: setup supertab in cmp
        {
          "hrsh7th/nvim-cmp",
          dependencies = {
            "hrsh7th/cmp-emoji",
          },
          ---@param opts cmp.ConfigSchema
          opts = function(_, opts)
            local has_words_before = function()
              unpack = unpack or table.unpack
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                  -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                  -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            })
          end,
        },
      }
    '';

    "${config.xdg.configHome}/lazyvim/init.lua".text = ''
      -- bootstrap lazy.nvim, LazyVim and your plugins
      require("config.lazy")
    '';

    "${config.xdg.configHome}/lazyvim/stylua.toml".text = ''
      indent_type = "Spaces"
      indent_width = 2
      column_width = 120
    '';

    "${config.xdg.configHome}/lazyvim/.neoconf.json".source =
      pkgs.fetchFromGitHub {
        owner = "LazyVim";
        repo = "starter";
        rev = "92b2689e6f11004e65376e84912e61b9e6c58827";
        hash = "sha256-gE2tRpglA0SxxjGN+uKwkwdR5YurvjVGf8SRKkW0E1U=";
      }
      + "/.neoconf.json";

    #### LazyVim End ####
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/easynix/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    NVIM_APPNAME = "lazyvim";
    FZF_DEFAULT_OPTS = "--no-height";
    FLAKE = "/home/easynix/nix-config";
  };

  services = {
    vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true; # default: false
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        favicon_service = "twenty";
        search_files_in_root = true;
        font = {
          normal = {
            size = 12;
            normal = "Maple Nerd Font";
          };
        };
        theme = {
          #light = {
          #  name = "vicinae-light";
          #  icon_theme = "default";
          #};
          #dark = {
          #  name = "vicinae-dark";
          #  icon_theme = "default";
          #};
          light = {
            name = "ayu-dark";
            icon_theme = "default";
          };
          dark = {
            name = "ayu-dark";
            icon_theme = "default";
          };
        };
        launcher_window = {
          opacity = 0.98;
        };
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        process-manager
        bluetooth
        nix
        power-profile
        #systemd
        vscode-recents
        # Extension names can be found in the link below, it's just the folder names
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    google-chrome = {
      enable = true;
    };

    wezterm = {
      enable = true;
      #package = inputs.wezterm-flake.packages.${pkgs.system}.default;
      extraConfig = ''
        -- Your lua code / config here
        return {
          font = wezterm.font 'Hack Nerd Font',
          font_size = 12.0,
          color_scheme = "Tokyo Night",
          
          -- front_end = "WebGpu",
          -- webgpu_power_preference = 'HighPerformance',
        }
      '';
    };

    kitty = {
      enable = true;

      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        mouse_hide_wait = "2.0";
        hide_window_decorations = "yes";
        window_padding_width = "1 1";
      };

      font = {
        name = "Hack Nerd";
        size = 12;
      };
    };

    neovim = {
      enable = true;
      # Use ${system} instead of x86_64-linux
      #package = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.neovim-unwrapped;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      viAlias = true;
      withPython3 = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = false;
    };

    jq.enable = true;

    fish = {
      enable = true;

      shellAliases = {
        ls = "exa";
        ll = "exa -l --icons -s type";
        lh = "exa -lah --icons -s type";
        lt = "exa -lT --icons -s type";
        lr = "exa -ls modified --icons";
        tide-config = "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Disconnected --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Many icons' --transient=Yes";
      };

      shellInit = ''
        set -g theme_display_git yes
        set -g theme_display_git_dirty yes
        set -g theme_display_git_untracked no
        set -g theme_display_git_ahead_verbose no
        set -g theme_display_git_dirty_verbose yes
        set -g theme_display_git_stashed_verbose no
        set -g theme_display_git_master_branch yes
        set -g theme_git_worktree_support false
        set -g theme_display_vagrant no
        set -g theme_display_docker_machine no
        set -g theme_display_k8s_context no
        set -g theme_display_hg no
        set -g theme_display_virtualenv no
        set -g theme_display_ruby yes
        set -g theme_display_nvm yes
        set -g theme_display_user ssh
        set -g theme_display_hostname ssh
        set -g theme_display_vi no
        set -g theme_display_date yes
        set -g theme_display_cmd_duration yes
        set -g theme_title_display_process yes
        set -g theme_title_display_path no
        set -g theme_title_display_user yes
        set -g theme_title_use_abbreviated_path no
        set -g theme_date_format "+%a %H:%M"
        set -g theme_avoid_ambiguous_glyphs no
        set -g theme_powerline_fonts yes
        set -g theme_nerd_fonts yes
        set -g theme_show_exit_status yes
        set -g theme_color_scheme dark
        set -g fish_prompt_pwd_dir_length 0
        set -g theme_project_dir_length 1
        set -g theme_newline_cursor yes
        set -g theme_newline_prompt '#> '
        set -g theme_display_logo yes
        set -g fish_color_search_match --background='333'

        fzf_configure_bindings --directory=\cf --variables=\e\cv
      '';

      plugins = [
        {
          name = "prompt-tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "main";
            hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
          };
        }
        {
          name = "grc";
          src = pkgs.fetchFromGitHub {
            owner = "orefalo";
            repo = "grc";
            rev = "master";
            hash = "sha256-iHlxCEKYyKHlIpyOz4bwTQ6R0lr7FqZb54/wuWfWQfg=";
          };
        }
        # {
        #   name = "bobthefish";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "oh-my-fish";
        #     repo = "theme-bobthefish";
        #     rev = "master";
        #     hash = "sha256-LB4g+EA3C7OxTuHfcxfgl8IVBe5NufFc+5z9VcS0Bt0=";
        #   };
        # }
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Vladimir Kravets";
          email = "vova.kravets@gmail.com";
        };
      };
      lfs.enable = true;
      # difftastic = {
      #   enable = true;
      #   background = "dark";
      # };
      # diff-so-fancy = {
      #   enable = true;
      # };
    };
  };

  # gtk = {
  #   enable = true;
  # };

  dconf = {
    enable = true;

    settings = {

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
        natural-scroll = false;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = false;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        repeat-interval = 15;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs; [
          #gnomeExtensions.user-themes.extensionUuid
          gnomeExtensions.dash-to-dock.extensionUuid
          gnomeExtensions.appindicator.extensionUuid
          #gnomeExtensions.clipboard-indicator.extensionUuid
          gnomeExtensions.status-area-horizontal-spacing.extensionUuid
          gnomeExtensions.random-wallpaper.extensionUuid
          gnomeExtensions.gnome-40-ui-improvements.extensionUuid
          gnomeExtensions.no-overview.extensionUuid
          gnomeExtensions.lockscreen-extension.extensionUuid
          gnomeExtensions.vicinae.extensionUuid
          #"randomwallpaper@iflow.space"
        ];
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          #"com.mitchellh.ghostty.desktop"
          #"kitty.desktop"
          "org.wezfurlong.wezterm.desktop"
          "google-chrome.desktop"
          #"idea-ultimate.desktop"
        ];
      };
      "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
        hpadding = 0;
      };
      #"org/gnome/shell/extensions/clipboard-indicator" = {
      #  history-size = 100;
      #  notify-on-copy = true;
      #  toggle-menu = [ "<Control><Alt>v" ];
      #};
      "org/gnome/shell/extensions/space-iflow-randomwallpaper" = {
        source = "unsplash";
      };
      "org/gnome/shell/extensions/space-iflow-randomwallpaper/unsplash" = {
        unsplash-image-height = 1080;
        unsplash-image-width = 1920;
        unsplash-keyword = "anime, girls, car, forest, nature";
      };
      "org/gnome/shell/extensions/lockscreen-extension" = {
        gradient-direction-1 = "none";
        background-size-1 = "cover";
        blur-radius-1 = 9;
        blur-brightness-1 = 0.35;
      };
    };
  };

  fonts.fontconfig.enable = true;

  # Remove extra auto loading fzf key bindings init
  home.extraProfileCommands = ''
    # unlink $out/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
    # unlink $out/share/fish/vendor_functions.d/fzf_key_bindings.fish
  '';

  systemd.user.startServices = "sd-switch";
}
