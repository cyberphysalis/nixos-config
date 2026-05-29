{ pkgs, config, lib, ... }@inputs:

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
  disabledModules = [ "programs/chromium.nix" ];
  imports = [
    inputs.noctalia.homeModules.default
    inputs.dms.homeModules.dank-material-shell
    ./ug-chromium.nix
  ];

  home.packages = (with pkgs; [
    swaylock-effects
    rustdesk-flutter
    inputs.zen-browser.packages."${system}".default
    #inputs.nixpkgs-unstable.ayugram-desktop
    inputs.ayugram-desktop.packages.${system}.ayugram-desktop
    vscode-modified.fhs
    spotify
    inputs.nixpkgs-unstable.obsidian
    #inputs.nixpkgs-unstable.discord
    discord-modified
    zed-fhs-patched
    foliate
    # for dms theme
    papirus-icon-theme
  ]) ++ (with inputs.nixpkgs-unstable; [
    #jetbrains.datagrip
  ]);

  services.flameshot = {
    enable = true;
    package = (pkgs.flameshot.override { enableWlrSupport = true; });
    settings.General = {
      useGrimAdapter = true;
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

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
    };

    enableSystemMonitoring = true;
    # dgop 用于监控系统性能, 在 25.11 中，nixpkgs 暂时不包含这个包，单独引入
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    # 在 dms gui 中更新配置时，会保存到  ~/.config/DankMaterialShell/settings.json 文件中
    # hm module 配置逻辑 https://github.com/AvengeMedia/DankMaterialShell/blob/master/distro/nix/home.nix
    # settings = {};
  };

  programs.noctalia-shell = {
    enable = false;
    systemd.enable = true;
    settings = {
      # configure noctalia here
      dock = {
        enabled = true;
        position = "top";
        displayMode = "auto_hide";
      };
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
        monitors = [ "DP-1" ];
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Hefei, China";
      };
    };
    # this may also be a string or a path to a JSON file.
  };

  programs.waybar = {
    enable = false;
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

  programs.chromium = {
    enable = true;
    package = inputs.nixpkgs-unstable.ungoogled-chromium;
    userDataDir = "${config.xdg.configHome}/.userdata/my-ug-chromium";
    extensions =
      let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
      in [
      {
        id = "lkbebcjgcmobigpeffafkodonchffocl";
        #crxPath = "${config.home.homeDirectory}/nixos/chromium-extensions/bpc.crx";
        crxPath = "/home/physails/nixos/chromium-extensions/bpc.crx";
        version = "4.3.0.2";
      }
      # {
      #   id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
      #   updateUrl = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=2026.315.1814&x=id%3Dddkjiahejlhfcafbddmgiahcphecmpfh%26installsource%3Dondemand%26uc";
      #   version = "2026.315.1814";
      # } # ublock origin lite
      (createChromiumExtension {
        id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
        version = "2026.315.1814";
        sha256 = "sha256:0n4x59a5k7d4396c95n67naw7zyiin3rm9a6k1g6jn0i0s5cxkk7";
      }) # ublock origin lite
    ];

    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      "--extension-mime-request-handling=always-prompt-for-install"
    ];
  };
}
