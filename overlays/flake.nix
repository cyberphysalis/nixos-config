{
  description = "A Nix-flake-based Node.js development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = { self, nixpkgs }:
    let
      overlays = [
        ( import ./claude-code-router )
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
            node2nix
            nodejs_20
            claude-code-router
          ];
        };
      });
    };
}
