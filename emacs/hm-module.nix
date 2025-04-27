{ pkgs, config, ... }@inputs:

{
  programs.emacs = {
    package = inputs.nixpkgs-unstable.emacs-pgtk;
    enable = true;
    # add config in here will rebuild emacs
    #extraConfig = "";
  };

  home.file = {
    ".emacs.d/init.el" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/emacs/init.el";
    };
    #".config/emacs" = {
    #  source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/emacs/config";
    #  recursive = true;
    #};
  };
}
