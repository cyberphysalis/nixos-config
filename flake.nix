{
  description = "A simple NixOS flake";

  # inputs 定义当前 flake 库的依赖项
  inputs = {
    # nixpkgs 依赖
    nixpkgs = {
      # url 属性定义依赖源；这里使用 NixOS 官方软件源 nixos-23.11 分支的 nju 镜像
      url = "git+https://mirror.nju.edu.cn/git/nixpkgs.git?ref=nixos-23.11";
    };

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager 依赖
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };


  # flake 的输出
  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    nixpkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
    };
    hyprland-pkgs = inputs.hyprland;
  in
  {
    # nixosConfigurations 即 NixOS 的系统配置文件，这是当前 flake 的输出
    # lib.nixosSystem 函数是 nixpkgs 依赖项提供的
    nixosConfigurations.wang-nix = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit nixpkgs-unstable hyprland-pkgs; };
      modules = [
        # 这里导入之前我们使用的 configuration.nix，
        # 这样旧的配置文件仍然能生效
        ./configuration.nix
        ./hyprland
        #hyprland.nixosMoudles.default
        #{ programs.hyprland.enable = true; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.physails.imports = [
            ./physails.nix
            ./hyprland/hm.nix
          ];

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
          home-manager.extraSpecialArgs = {
            #inherit (inputs) hyprland-pkgs nixpkgs-unstable;
            inherit hyprland-pkgs nixpkgs-unstable;
          };
        }
      ];
    };
  };
}
