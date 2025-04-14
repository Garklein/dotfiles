{ config, pkgs, inputs, ... }:

{
  imports = [
    modules/firefox.nix
    modules/git.nix
  ];

  home.username = "gator";
  home.homeDirectory = "/home/gator";

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME";
      download = "/tmp";
      documents = "$HOME";
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    agave feh python3 perl alsa-utils unzip easyeffects neofetch vim alacritty webcord xclip maim snobol4
    xidlehook
  ];

  services.picom.enable = true;

  home.file = let
    link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/${path}";
  in {
    ".emacs.d".source = link ".emacs.d";
    ".config/alacritty".source = link ".config/alacritty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
