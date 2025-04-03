{ pkgs, lib, config, ...}@inputs:
{
  programs.niri = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.niri ];
    config = {
      niri = {
        default = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  # input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      # 不使用用户空间配置
      #ignoreUserConfig = true;
      addons = with pkgs; [
        #librime
        #rime-data
        # for flypy chinese input method
        # needed enable rime using configtool after installed
        fcitx5-configtool
        fcitx5-chinese-addons
        (fcitx5-rime.override {
          rimeDataPkgs = [
            ../rime
          ];
        })
        # fcitx5-mozc    # japanese input method
        fcitx5-gtk # gtk im module
        kdePackages.fcitx5-qt # qt library
        #fcitx5-pinyin-zhwiki
      ];
      # 因为前面忽略了用户空间配置，这里要提前配置好默认项
      settings.globalOptions = {
        "Hotkey/TriggerKeys" = {
          "0" = "Control+space";
        };
      };
      settings.inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "rime";
          Layout = "";
        };
        "GroupOrder" = {
          "0" = "Default";
        };
      };
    };
  };
  
}

