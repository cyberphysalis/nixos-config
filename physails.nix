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

  home.packages = with pkgs; [
    unzipNLS
  ];

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
    initExtra = ''
      function zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_LAST
        ZVM_KEYTIMEOUT=0.1
        ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
      }
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
     
      # Make Tab and ShiftTab go to the menu
      bindkey              '^I' menu-select
      bindkey "$terminfo[kcbt]" menu-select
      # Make Tab and ShiftTab change the selection in the menu
      bindkey -M menuselect              '^I'         menu-complete
      bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

      source <(zoxide init --cmd cd zsh)
      eval "$(fzf --zsh)"
    '';
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
