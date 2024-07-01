{ pkgs, lib, ...}@inputs:
let
  hyprPkgFromFlake = inputs.hyprland-pkgs.packages.${pkgs.system}.hyprland;
in
{
  #pkgs.config.pulseaudio = true;
  # https://wiki.hyprland.org/nix/hyprland-on-nixos/
  # 需要在 flake.nix 中添加 hyprland 源
  #programs.hyprland = {
  #  enable = true;
  #  package = hyprPkgFromFlake;
  #  xwayland.enable = true;
  #};

  #services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${hyprPkgFromFlake}/share/wayland-sessions";
        user = "physails";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # critical components needed to run Hyprland properly
  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/programs/hyprland.nix
  #
  security.polkit.enable = true;
  #security.polkit.debug = true;
  #security.wrappers = {
  #  clash = {
  #    setuid = true;
  #    setgid = true;
  #    owner = "root";
  #    group = "root";
  #    #capabilities = "cap_net_bind_service,cap_net_admin=+ep";
  #    source = "${inputs.nixpkgs-unstable.clash-verge-rev}/bin/clash-meta";
  #  };
  #};

  # for swaylock to unlock screen
  security.pam.services.swaylock = {};

  hardware.opengl.enable = true;

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      (pkgs.xdg-desktop-portal-hyprland.override { hyprland = hyprPkgFromFlake; })
    ];
    configPackages = [ hyprPkgFromFlake ];
  };

  # input method
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      fcitx5-rime
      # needed enable rime using configtool after installed
      fcitx5-configtool
      fcitx5-chinese-addons
      # fcitx5-mozc    # japanese input method
      fcitx5-gtk # gtk im module
    ];
  };
}

