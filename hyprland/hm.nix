{ config, pkgs, ... }@inputs:
let
  hyprPkgFromFlake = inputs.hyprland-pkgs.packages.${pkgs.system}.hyprland;
  waybarConfigFile = ./config/waybar/config.json;
  waybarConfig = pkgs.runCommand "config.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
    jq -nf ${waybarConfigFile} > $out
  '';
in
{
  home.packages = with pkgs; [
    libnotify
    swaylock-effects
  ] ++ [
    inputs.nixpkgs-unstable.clash-verge-rev
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprPkgFromFlake;
    extraConfig = builtins.readFile ./config/hyprland.conf;

    xwayland.enable = true;
    systemd.enable = true;
  };

  #  和 systemd.enable 冲突
  # home.file.".config/hypr/hyprland.conf".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/hyprland/config/hyprland.conf";

  # web browser
  # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
  programs.google-chrome = {
    enable = true;

    # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
      # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
      # (only supported by chromium/chrome at this time, not electron)
      "--gtk-version=4"
      # make it use text-input-v1, which works for kwin 5.27 and weston
      "--enable-wayland-ime"

      # enable hardware acceleration - vulkan api
      # "--enable-features=Vulkan"
    ];
  };

  #xdg.desktopEntries.chrome = {
  #  name = "chrome";
  #  genericName = "Web Brower";
  #  exec = "google-chrome-stable";
  #  terminal = false;
  #  categories = [ "Application" "WebBrowser" ];
  #  mimeType = [ "text/html" "text/xml" ];

  #  actions = {
  #   "New-Window" = { exec = "google-chrome-stable --new-window"; };
  #  };
  #};


  # stauts bar
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    #settings = {
    #  mainbar = builtins.fromJSON (builtins.readFile waybarConfig);
    #};
    #settings = (builtins.fromJSON (builtins.readFile ./config/waybar/test.json));
    #style = ./config/waybar/style.css;
  };

  home.file = {
    ".config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/hyprland/config/waybar";
      recursive = true;
    };

    ".config/hypr/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/hyprland/scripts";
      recursive = true;
    };
  };

  # notification
  services.mako = {
    enable = true;
    actions = true;
    anchor = "top-right";
    extraConfig = builtins.readFile ./config/mako/config;
  };

  # app launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}
