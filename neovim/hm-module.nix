{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
  };

  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/neovim/config";
      recursive = true;
    };
  };
}
