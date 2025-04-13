{ config, pkgs, ... }:

{
  imports =
    [ modules/firefox.nix
      modules/git.nix
    ];

  home.username = "gator";
  home.homeDirectory = "/home/gator";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    agave gh
  ];

  home.file = {
    ".emacs.d/init.el".source = dotfiles/.emacs.d/init.el;
    ".emacs.d/config.org".source = dotfiles/.emacs.d/config.org;
    ".emacs.d/custom.el".source = dotfiles/.emacs.d/custom.el;
    ".emacs.d/lisp".source = dotfiles/.emacs.d/lisp;
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
