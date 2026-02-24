{ config, pkgs, inputs, lib, ... }:

let
  bruh = pkgs.dyalog.override { acceptLicense = true; };
  # zulu is java
  languages = with pkgs; [python3 uv perl snobol4 gcc ngn-k ghc cargo ruby_3_4 nodejs sbcl cabal-install lean4 bruh ride uiua-unstable uiua386 binaryen zulu25 scryer-prolog pharo];
  wmpackages = with pkgs; [agave ubuntu-sans alsa-utils xclip maim xidlehook liberation_ttf]; # for exwm setup
  editors = with pkgs; [vim ed emacs-gtk];
  utils = with pkgs; [unzip man-pages gnumake valgrind emscripten rlwrap wine ripgrep nettools];
  tools = with pkgs; [feh ffmpeg imagemagick pdftk ghostscript gimp vlc cmus scc zip xorg.xrandr gnuplot audacity typst garamond-libre blender yt-dlp];
  discords = with pkgs; [webcord easyeffects discord];
  iostools = with pkgs; [ifuse libimobiledevice jmtpfs];
  misc = with pkgs; [neofetch figlet obs-studio quickjs-ng curl];
  school = with pkgs; [go];
in {
  imports = [
    modules/firefox.nix
    modules/git.nix
    modules/visuals.nix
    modules/bash.nix
    modules/xdg.nix
    modules/alacritty.nix
  ];

  home.packages = lib.lists.flatten [languages wmpackages editors utils tools discords iostools misc school];

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
