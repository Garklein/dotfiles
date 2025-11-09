{ config, pkgs, inputs, lib, ... }:

let
  # zulu is java
  languages = with pkgs; [python3 uv perl snobol4 gcc ngn-k ghc cargo ruby nodejs sbcl cabal-install zulu24 scryer-prolog];
  wmpackages = with pkgs; [agave ubuntu-sans alsa-utils xclip maim xidlehook liberation_ttf]; # for exwm setup
  editors = with pkgs; [vim ed emacs-gtk arduino-ide];
  utils = with pkgs; [unzip man-pages gnumake valgrind emscripten rlwrap wine ripgrep nettools];
  tools = with pkgs; [feh ffmpeg imagemagick ghostscript gimp vlc cmus scc zip xorg.xrandr gnuplot];
  discords = with pkgs; [webcord easyeffects discord];
  iostools = with pkgs; [ifuse libimobiledevice];
  misc = with pkgs; [neofetch figlet];
in {
  imports = [
    modules/firefox.nix
    modules/git.nix
    modules/visuals.nix
    modules/bash.nix
    modules/xdg.nix
    modules/alacritty.nix
  ];

  home.packages = lib.lists.flatten [languages wmpackages editors utils tools discords iostools misc];

  home.username = "gator";
  home.homeDirectory = "/home/gator";

  home.file = let
    # editable symlink
    link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/${path}";
  in {
    ".emacs.d".source = link ".emacs.d";
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
