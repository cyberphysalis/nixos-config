# Options 
# https://nix-community.github.io/home-manager/options.xhtml
#
{ config, pkgs, ... }@inputs:

{
  home.stateVersion = "23.11";

  #home.username = "physails";
  #home.homeDirectory = "/home/physails";
  programs.bash = {
    enable = true;
    enableCompletion = true;
    #  Note that these commands will be run even in non-interactive
    # fix problem that unpatched binary can't execute
    # https://www.reddit.com/r/NixOS/comments/13uc87h/masonnvim_broke_on_nixos/
    initExtra = ''
      source <(zoxide init --cmd cd bash)
      eval "$(fzf --bash)"
    '';
    bashrcExtra = ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
    '';
  };

  home.packages = (with pkgs; [
    unzipNLS
    (writeShellScriptBin "install-overlays" (builtins.readFile ./overlays/install-overlays.sh))
  ]) ++ (with inputs.nixpkgs-unstable; [
    lazygit
    aider-chat-with-browser
  ]);

  programs.vim = {
    enable = true;
    defaultEditor = true;
    # color code
    # https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
    extraConfig = ''
      set nu
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      syntax on
      colorscheme default
      set list
      " highlight cursor line
      set cursorline
      hi CursorLineNr   cterm=NONE ctermbg=None ctermfg=None
      hi CursorLine     cterm=NONE ctermbg=237 ctermfg=None
      " auto jump to last editing line when open 
      if has("autocmd")
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
      endif
    '';
  };

  programs.git = {
    enable = true;
    userName = "cyberphysails";
    userEmail = "physqils@outlook.com";
    extraConfig = {
      http."https://github.com".proxy = "socks5://192.168.66.12:2080";
    };
  };


  programs.ssh = {
    enable = true;
    matchBlocks = import "${inputs.physails-secrets}/ssh-hosts-config.nix";
    #matchBlocks = inputs.physails-secrets.ssh-hosts-config;
#      "github.com" = {
#        hostname = "github.com";
#        identityFile = "/home/physails/.ssh/github_rsa";
#        identitiesOnly = true;
#      };
      ##      "gitlab.bitahub.com" = {
#        hostname = "10.0.100.128";
#        identityFile = "/home/physails/.ssh/gitlab_bitahub_rsa";
    #};
  };
  
  programs.alacritty = {
    enable = true;
    # settings 值是一个 TOML value
    # https://alacritty.org/config-alacritty.html
    settings = {
      env = {
        # use `infocmp xterm-256color` to check terminfo
        "TERM" = "xterm-256color";
      };
      selection = { save_to_clipboard = true; };
      font = {
        normal = {
          # family = "Maple Mono SC NF";
          family = "Maple Mono CN";
          style = "Regular";
        };
        size = 12;
      };
      window = {
        blur = true;
        opacity = 0.9;
      };
      terminal = {
        osc52 = "CopyPaste";
      };
    };
  };
  
  # 截止到 1.1.3 版本，在 Wayland 版本中，primary copyboard 无法和 default copyboard 互通，在终端中的复制内容无法粘贴到浏览器中
  programs.ghostty = {
    enable = true;
    package = inputs.nixpkgs-unstable.ghostty;
    settings = {
      font-family = "Maple Mono CN";
      background-opacity = 0.8;
      clipboard-read = "allow";
      clipboard-write = "allow";
      # TERM env, 默认是 xterm-ghostty 在使用 ssh 登录到其他服务器时会影响色彩输出
      term = "xterm-256color";
    };
  };

  programs.wezterm = {
    enable = true;
    package = inputs.nixpkgs-unstable.wezterm;
    enableZshIntegration = true;
    extraConfig = ''
      local config = wezterm.config_builder()
      local action = wezterm.action

      -- gpu config
      config.front_end = 'WebGpu'
      config.webgpu_preferred_adapter = {
        backend = 'Vulkan',
        device = 8644,
        device_type = 'DiscreteGpu',
        driver = 'radv'  ,
        driver_info = '570.153.02',
        name = 'NVIDIA GeForce GTX 1660 SUPER',
        vendor = 4318,
      }
      config.webgpu_power_preference = "HighPerformance"

      -- config.color_scheme = 'Kimber (base16)'
      -- config.color_scheme = 'Blazer (Gogh)'
      -- config.color_scheme = 'Breeze'

      -- config.color_scheme = 'Bleh-1 (terminal.sexy)'
      config.color_scheme = 'Catppuccin Mocha (Gogh)'
      
      -- tab bars
      config.enable_tab_bar = true
      
      config.hide_tab_bar_if_only_one_tab = true
      config.use_fancy_tab_bar = true
      config.show_close_tab_button_in_tabs = false
      config.show_new_tab_button_in_tab_bar = false
      config.window_decorations = "NONE"
      config.window_background_opacity = 0.8
      config.window_frame = {
          font_size = 12;
      }
      
      config.leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 }
      config.keys = {
        -- This will create a new split and run your default program inside it
        { key = [[/]], mods = 'CTRL', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = [[(]], mods = 'CTRL|SHIFT', action = action.CloseCurrentPane({ confirm = true }) },
        -- { key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
        { key = "t", mods = 'ALT', action = action.SpawnTab("CurrentPaneDomain") },
        { key = "k", mods = 'LEADER', action = action.ActivatePaneDirection("Up") },
        { key = "j", mods = 'LEADER', action = action.ActivatePaneDirection("Down") },
        { key = "h", mods = 'LEADER', action = action.ActivatePaneDirection("Left") },
        { key = "l", mods = 'LEADER', action = action.ActivatePaneDirection("Right") },
      }
      config.enable_scroll_bar = true
      config.font = wezterm.font 'Maple Mono CN'
      return config
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = false;
    };
    enableCompletion = false;
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
      #{
      #  name = "vi-mode";
      #  src = pkgs.zsh-vi-mode;
      #  file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      #}
    ];
    initContent = ''
      function zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_LAST
        ZVM_KEYTIMEOUT=0.1
        ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
      }
      function zvm_after_init() {
        eval "$(fzf --zsh)"
        eval "$(atuin init zsh --disable-up-arrow)"
      }
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
     
      # Make Tab and ShiftTab go to the menu
      bindkey              '^I' menu-select
      bindkey "$terminfo[kcbt]" menu-select
      # Make Tab and ShiftTab change the selection in the menu
      bindkey -M menuselect              '^I'         menu-complete
      bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

      source <(zoxide init --cmd cd zsh)
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      nix_shell = {
        disabled = false;
      };
      kubernetes = {
        detect_env_vars = [ "KUBECONFIG" ];
        disabled = false;
      };
    };
  };

  programs.direnv = {
      enable = true;
      enableZshIntegration = false; # see note on other shells below
      nix-direnv.enable = true;
  };

  programs.tmux = {
   enable = true;
   extraConfig = ''
     unbind C-a
     set  -g prefix C-a
     bind C-a send-prefix
     # panel and window numbering base 1
     set  -g base-index 1
     setw -g pane-base-index 1
     # when delete one window, renumber window index
     set  -g renumber-windows on

     set-environment -g WAYLAND_DISPLAY "wayland-1"

     # # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
     set -g default-terminal "xterm-256color"
     set -ga terminal-overrides ",*256col*:Tc"
     set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
     set-environment -g COLORTERM "truecolor"

     set  -g aggressive-resize on
     set  -g mouse on
     set  -g clock-mode-style 24
     set  -gw window-status-current-style fg=white
     bind -T prefix Enter new-window
     bind -N "Select pane to the left of the active pane" h select-pane -L
     bind -N "Select pane below the active pane" j select-pane -D
     bind -N "Select pane above the active pane" k select-pane -U
     bind -N "Select pane to the right of the active pane" l select-pane -R
     bind-key -T prefix b last-window

     bind -N "Rename current window" r command-prompt -I "#W" "rename-window '%%'"
     set -g mode-keys vi
     set -s copy-command 'wl-copy -p'
     set -s set-clipboard on
     unbind -T copy-mode-vi Enter
     # https://github.com/tmux/tmux/commit/76d6d3641f271be1756e41494960d96714e7ee58
     bind -T copy-mode-vi q send-keys -X cancel
     bind -T copy-mode-vi Escape send-keys -X clear-selection
     bind -T copy-mode-vi v send-keys -X begin-selection
     bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
     bind -T copy-mode-vi MouseDrag1Pane select-pane \; send-keys -X begin-selection
     bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe
   '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      keymap_mode = "vim-insert";
      enter_accept = true;
    };
  };
  #home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  
 # wayland.windowManager.hyprland = {
  #  enable = true;
  #  extraConfig = (builtins.readFile ./hyprland/hyprland.conf);
  #  xwayland.enable = true;
  #  
  #  systemd.enable = true;
  #  package = config.wayland.windowManager.hyprland.package.override {
  #    debug = true;
  #  };
#  };

  programs.home-manager.enable = true; 
}
