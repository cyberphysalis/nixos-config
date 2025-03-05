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
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      syntax on
      colorscheme default
      set list
      set cursorline
      hi CursorLineNr   cterm=NONE ctermbg=None ctermfg=None
      hi CursorLine     cterm=NONE ctermbg=243 ctermfg=white
    '';
  };

  programs.git = {
    enable = true;
    userName = "cyberphysails";
    userEmail = "physqils@outlook.com";
    extraConfig = {
      http."https://github.com".proxy = "socks5://192.168.66.11:7890";
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
          family = "Maple Mono SC NF";
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
      enable = true;
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
    ];
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
