{ pkgs, config, ... }@inputs:

let
  vscode-modified = pkgs.vscode.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
    postInstall = (oldAttrs.postInstall or "")  + ''
      mv $out/bin/code $out/bin/code-original
      makeWrapper $out/bin/code-original $out/bin/code \
        --add-flags "--disable-gpu --enable-wayland-ime --wayland-text-input-version=3"
    '';
  });
in
{
  home.packages = with pkgs; [
    swaylock-effects
    rustdesk-flutter
    inputs.zen-browser.packages."${system}".default
    inputs.nixpkgs-unstable.ayugram-desktop
    #inputs.ayugram-desktop.packages.${system}.ayugram-desktop
    vscode-modified.fhs
    spotify
  ];

  services.flameshot = {
    enable = true;
    package = (pkgs.flameshot.override { enableWlrSupport = true; });
    settings.General = {
      showStartupLaunchMessage = false;
    };
  };

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

  # programs.niri = {
  #   config = (builtins.readFile ./config.kdl);
  # };
  home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/niri/config.kdl";

  #programs.google-chrome = {
  #programs.chromium = {
  programs.vivaldi = {
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
}
