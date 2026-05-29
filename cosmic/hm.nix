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
  discord-modified = inputs.nixpkgs-unstable.discord.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
    # "Discord" 是 binaryName 变量的值，对不同的版本需要替换，这里没找到直接使用 binaryName 变量的方法
    postInstall = (oldAttrs.postInstall or "")  + ''
      mv $out/bin/Discord $out/bin/Discord-original
      makeWrapper $out/bin/Discord-original $out/bin/Discord \
        --add-flags "--disable-gpu --enable-wayland-ime --wayland-text-input-version=3"
    '';
  });
  # https://github.com/nix-community/home-manager/issues/322#issuecomment-1178614454
  openssh-patched = pkgs.openssh.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ ./openssh-nocheckcfg.patch ];
  });
  # https://github.com/nix-community/home-manager/issues/322#issuecomment-2265431023
  zed-fhs-patched = inputs.nixpkgs-unstable.zed-editor.fhsWithPackages (_: [ openssh-patched ]);
in
{
  home.packages = (with pkgs; [
    #swaylock-effects
    rustdesk-flutter
    inputs.zen-browser.packages."${system}".default
    #inputs.nixpkgs-unstable.ayugram-desktop
    inputs.ayugram-desktop.packages.${system}.ayugram-desktop
    vscode-modified.fhs
    spotify
    inputs.nixpkgs-unstable.obsidian
    #inputs.nixpkgs-unstable.discord
    discord-modified
    #inputs.nixpkgs-unstable.zed-editor-fhs
    zed-fhs-patched
  ]) ++ (with inputs.nixpkgs-unstable; [
    jetbrains.datagrip
  ]);

  services.flameshot = {
    enable = true;
    package = (pkgs.flameshot.override { enableWlrSupport = true; });
    settings.General = {
      showStartupLaunchMessage = false;
    };
  };

  #programs.fuzzel = {
  #  enable = true;
  #  # https://codeberg.org/dnkl/fuzzel/src/branch/master/doc/fuzzel.ini.5.scd
  #  #settings = {};
  #};

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
