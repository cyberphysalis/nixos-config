# Options 
# https://nix-community.github.io/home-manager/options.xhtml
#
{ config, pkgs, ... }:

{
  home.stateVersion = "23.11";

  #home.username = "physails";
  #home.homeDirectory = "/home/physails";
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
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "/home/physails/.ssh/github_rsa";
        identitiesOnly = true;
      };
    };
  };
  
  
  #home.packages = with pkgs: [
  #  alacritty
  #];
  
  programs.alacritty = {
    enable = true;
    # settings 值是一个 TOML value
    # https://alacritty.org/config-alacritty.html 
    settings = {
      selection = { save_to_clipboard = true; };
#      font = { size = 12; };
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
