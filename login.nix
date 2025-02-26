{ pkgs, lib, ...}@inputs:
let
  tuigreet = lib.getExe pkgs.greetd.tuigreet;
  sessions-dir = "${pkgs.niri-stable}/share/wayland-sessions";
  #niri-session = "/run/current-system/sw/bin/niri-session";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
        #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${hyprPkgFromFlake}/share/wayland-sessions";
        command = "${tuigreet} -i --asterisks --time --remember --remember-session --sessions ${sessions-dir}";
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
}
