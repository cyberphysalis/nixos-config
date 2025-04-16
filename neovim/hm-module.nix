{ pkgs, config, ... }@inputs:

{
  programs.neovim = {
    package = inputs.nixpkgs-unstable.neovim-unwrapped;
    enable = true;
  };

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/neovim/config";
      recursive = true;
    };
  };
}
