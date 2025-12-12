{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      overlays = [
        ( import ./claude-code-router )
        inputs.claude-code.overlays.default
      ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit overlays system;
          config.allowUnfree = true;
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        claude-code-router = pkgs.mkShell {
          packages = with pkgs; [
            claude-code-router
            claude-code
            nodejs_24
          ];
          shellHook = ''
            name='claude-code-router.dev'
          '';
        };
      });
    };
}
