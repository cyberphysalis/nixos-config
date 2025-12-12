{
  description = "A simple NixOS flake";

  # inputs 定义当前 flake 库的依赖项
  inputs = {
    # nixpkgs 依赖
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # url 属性定义依赖源；这里使用 NixOS 官方软件源 nixos-23.11 分支的 nju 镜像
    #nixpkgs.url = "git+https://mirror.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager 依赖
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master"; 
      inputs.nixpkgs.follows = "nixpkgs-unstable"; 
    };

    hyprland.url = "github:hyprwm/Hyprland";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs"; 
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      #inputs.nixpkgs.follows = "nixos-cosmic/nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # inputs.nixpkgs.follows = "nixpkgs"; 
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    physails-secrets = {
      #url = "path:/home/physails/physails-secrets";
      #url = "git+ssh://git@github.com/cyberphysails/secrets.git?shallow=1";
      url = "git+https://github.com/cyberphysails/secrets.git?shallow=1";
      flake = false;
    };
  };


  # flake 的输出
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    nixpkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    hyprland-pkgs = inputs.hyprland;
    physails-secrets = inputs.physails-secrets;
    niri = inputs.niri;
    cosmic = inputs.nixos-cosmic;
    zen-browser = inputs.zen-browser;
    nur = inputs.nur;
    ayugram-desktop = inputs.ayugram-desktop;
  in
  {
    # nixosConfigurations 即 NixOS 的系统配置文件，这是当前 flake 的输出
    # lib.nixosSystem 函数是 nixpkgs 依赖项提供的
    nixosConfigurations.wang-nix = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit nixpkgs-unstable hyprland-pkgs physails-secrets niri cosmic zen-browser nur ayugram-desktop; };
      modules = [
        # 这里导入之前我们使用的 configuration.nix，
        # 这样旧的配置文件仍然能生效
        ./configuration.nix
        ./login.nix
        niri.nixosModules.niri
        ./niri/niri.nix
        cosmic.nixosModules.default
        #./cosmic/cosmic.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.physails.imports = [
            ./physails.nix
            ./niri/hm.nix
            #./cosmic/hm.nix
            ./neovim/hm-module.nix
            ./emacs/hm-module.nix
          ];

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            #inherit (inputs) hyprland-pkgs nixpkgs-unstable;
            inherit hyprland-pkgs nixpkgs-unstable zen-browser nur physails-secrets ayugram-desktop;
          };
        }
      ];
    };
  };
}
