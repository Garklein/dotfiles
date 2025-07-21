{ config, pkgs, inputs, lib, ... }:

let
  languages = with pkgs; [python3 uv perl snobol4 gcc ngn-k ghc cargo ruby nodejs sbcl cabal-install];
  wmpackages = with pkgs; [agave alsa-utils xclip maim xidlehook]; # for exwm setup
  editors = with pkgs; [vim ed emacs-gtk];
  utils = with pkgs; [silver-searcher unzip man-pages gnumake valgrind emscripten rlwrap wine];
  tools = with pkgs; [feh ffmpeg imagemagick ghostscript gimp vlc cmus scc];
  discords = with pkgs; [webcord easyeffects discord];
  iostools = with pkgs; [ifuse libimobiledevice];
  work = with pkgs; [zoom-us claude-code google-chrome];
  misc = with pkgs; [neofetch];
in {
  imports = [
    modules/firefox.nix
    modules/git.nix
    modules/visuals.nix
    modules/bash.nix
    modules/xdg.nix
    modules/alacritty.nix
  ];

  home.packages = [inputs.claude-desktop.packages.x86_64-linux.claude-desktop-with-fhs]
                  ++ (lib.lists.flatten [languages wmpackages editors utils tools discords iostools work misc]);

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
