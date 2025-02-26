{ pkgs, config, ... }@inputs:

{
  home.packages = with pkgs; [
    swaylock-effects
    rustdesk-flutter
    inputs.zen-browser.packages."${system}".default
  ];

  programs.fuzzel = {
    enable = true;
    # https://codeberg.org/dnkl/fuzzel/src/branch/master/doc/fuzzel.ini.5.scd
    #settings = {};
  };

  #programs.swaylock = {
  #  enable = true;
  #  # settings = {};
  #};

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 20;
      output = [
        "DP-1"
      ];
      modules-left = [ "niri/workspaces" "niri/window" ];
      modules-right = [ "clock" ];
      "niri/workspaces" = {
        format = "{value}";
      };
      "niri/window" = {
        format = "{title}";
      };
      clock = {
        timezone = "Asia/Shanghai";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d %H:%M}";
      };
    };
  };

  programs.niri = {
    config = (builtins.readFile ./config.kdl);
  };

  #programs.google-chrome = {
  programs.chromium = {
    enable = true;

    # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
      # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
      # (only supported by chromium/chrome at this time, not electron)
      #"--gtk-version=4"

      # make it use text-input-v1, which works for kwin 5.27 and weston
      #"--enable-wayland-ime"

      # make it use text-input-v3, https://github.com/YaLTeR/niri/issues/583#issuecomment-2282177305
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      # enable hardware acceleration - vulkan api
      #"--enable-features=Vulkan"
    ];
  };
 # home.file = {
 #   ".config/niri/config.kdl" = {
 #     source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/niri/config.kdl";
 #     recursive = false;
 #   };
 # };
}
