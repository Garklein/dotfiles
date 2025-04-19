{ config, pkgs, inputs, ... }:

{
  imports = [
    modules/firefox.nix
    modules/git.nix
    modules/wmpackages.nix
    modules/languages.nix
    modules/visuals.nix
    modules/bash.nix
    modules/xdg.nix
  ];

  home.packages = with pkgs; [
    webcord easyeffects
    vim ed wine
    alacritty neofetch
    feh silver-searcher
    unzip ffmpeg cmus
    gimp vlc
    ifuse libimobiledevice # for mounting ios
    emacs-gtk
  ];

  home.username = "gator";
  home.homeDirectory = "/home/gator";

  home.file = let
    # editable symlink
    link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/${path}";
  in {
    ".emacs.d".source = link ".emacs.d";
    ".config/alacritty".source = link ".config/alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
