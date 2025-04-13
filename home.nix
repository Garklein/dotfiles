{ config, pkgs, ... }:

{
  imports = [
    modules/firefox.nix
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
    agave gh feh python3 perl alsa-utils unzip easyeffects neofetch vim alacritty webcord
  ];

  services.picom.enable = true;

  home.file = {
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/.emacs.d";
  };

  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
