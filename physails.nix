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
    #  Note that these commands will be run even in non-interactive
    # fix problem that unpatched binary can't execute
    # https://www.reddit.com/r/NixOS/comments/13uc87h/masonnvim_broke_on_nixos/
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
    extraConfig = ''
set tabstop=2
set shiftwidth=2
set expandtab
syntax on
colorscheme default
set list
    '';
  };

  programs.git = {
    enable = true;
    userName = "cyberphysails";
    userEmail = "physqils@outlook.com";
    extraConfig = {
      http."https://github.com".proxy = "socks5://127.0.0.1:7890";
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
      selection = { save_to_clipboard = true; };
      font = { 
        normal = {
          family = "Maple Mono SC NF";
          style = "Regular";
        };
        size = 12;
      };
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
