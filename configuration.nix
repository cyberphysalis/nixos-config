# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

#{ inputs, config, lib, pkgs, ... }:
{ config, lib, pkgs, ... }@inputs:

{
  # 安装 nvidia drivers 的必要选项
  nixpkgs.config.allowUnfree = true;
  # explicit pulseaudio support in applications
  #nixpkgs.config.pulseaudio = true;

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
   
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ 
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
#    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://hyprland.cachix.org"
    "https://cache.garnix.io"
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  networking.hostName = "wang-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.interfaces.eno1.ipv4.addresses = [{
    address = "192.168.66.13";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.66.12";
  # nameserver must be ip address without port
  networking.nameservers = [ "192.168.66.12" ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts = {
    # 查看默认字体匹配项
    # FC_DEBUG=1 fc-match 'serif'
    enableDefaultPackages = true;
    packages = with pkgs; [
      #maple-mono-SC-NF
      #noto-fonts-emoji
      noto-fonts-color-emoji
      noto-fonts
      font-awesome
      wqy_zenhei
      wqy_microhei
      fira
#      source-sans
#      source-serif
#      source-han-sans
#      source-han-serif
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    #(nerdfonts.override { fonts = [
    #    "NerdFontsSymbolsOnly"
    #    "JetBrainsMono"
    #    "Iosevka"
    #  ];})
    ] ++ [
      inputs.nixpkgs-unstable.maple-mono.CN
      inputs.nixpkgs-unstable.maple-mono.Normal-TTF
    ];
    fontconfig.defaultFonts = {
      serif = [ "WenQuanYi Micro Hei" "Noto Color Emoji"];
      sansSerif = [ "WenQuanYi Micro Hei" "Noto Color Emoji"];
      monospace = [ "WenQuanYi Micro Hei Mono" "Noto Color Emoji"];
      #serif = [ "Maple Mono SC NF" "Font Awesome 6 Free" "Noto Color Emoji" "Source Han Serif SC" ];
      #sansSerif = [ "Maple Mono SC NF" "Font Awesome 6 Free" "Noto Color Emoji" "Source Han Sans SC" ];
      #monospace = [ "Maple Mono SC NF" "JetBrainsMono Nerd Font" "Font Awesome 6 Free" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.physails = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "render" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
   # packages = with pkgs; [
   #   firefox
   #   tree
   # ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #fish
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    pciutils
    openssl
    xdg-utils
    # some network tools like ping, telnet
    inetutils
    # for paste, copy tool
    lemonade
    wl-clipboard-rs
    zoxide
    fzf
    tree
    neofetch
    tmux
    screen
    #brightnessctl
    bluez
    swaybg
    # screenshot
    satty
  ];
  
  # 将 vim 设为默认编辑器
  environment.variables.EDITOR = "vim";
  
  # enable zsh to get completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.nix-ld.enable = true;

  programs.fish.enable = true;

  programs.zsh = {
    enable = true;
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.openssh.settings = {
  #  PermitRootLogin = "yes"; 
  #};

  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ "physails" ];
        commands = [
          { command = "ALL"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };

  # sound
  # Enable sound.
  # sound.enable = true;
  #hardware.pulseaudio = {
  #  enable = true;
  #  support32Bit = true;
  #
  #};
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # dns over https
  networking.resolvconf.useLocalResolver = false;

  services.kmonad = {
   enable = false;
     keyboards = {
       myKMonadOutput = {
         device = "/dev/input/by-id/usb-5000_Bluetooth_Keyboard-event-kbd";
         config = builtins.readFile ./kmonad.kbd;
       };
     };
  };

  services.kanata = {
   enable = true;
     keyboards = {
       myKanataOutput = {
         devices = [ "/dev/input/by-id/usb-5000_Bluetooth_Keyboard-event-kbd" ];
         extraDefCfg = ''
           process-unmapped-keys yes
         '';
         config = builtins.readFile ./kanata.kbd;
       };
     };
  };

  services.sing-box = {
    enable = false;
    package = inputs.nixpkgs-unstable.sing-box;
    settings = {
      experimental = {
        clash_api = {
          external_controller = "0.0.0.0:9090";
        };
      };
    };
  };
  
  #services.dnscrypt-proxy2 = {
  #  enable = false;
  #  settings = {
  #    ipv6_servers = true;
  #    require_dnssec = false;

  #    sources.public-resolvers = {
  #      urls = [
  #        "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
  #        "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  #      ];
  #      cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
  #      minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
  #    };

  #    bootstrap_resolvers = [ "223.5.5.5:53" "8.8.8.8:53" ];
  #    # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
  #    server_names = [
  #      "alidns-doh"
  #      "dnscry.pt-seoul-ipv4"
  #      "dnscry.pt-flint-ipv4"
  #    ];
  #  };
  #};

  #systemd.services.dnscrypt-proxy2.serviceConfig = {
  #  StateDirectory = "dnscrypt-proxy";
  #};

  #systemd.services.sing-box = {
  #  documentation = "https://sing-box.sagrenet.org";
  #  description = "sing-box service";
  #  after = [ "network.target" "nss-lookup.target"];
  #  serviceConfig = {
  #    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
  #    AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
  #    ExecStart = "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -C /etc/sing-box run";
  #    ExecReload = "${pkgs.sing-box}/";
  #  };
  #};

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
