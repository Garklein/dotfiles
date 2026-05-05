{ config, pkgs, inputs, lib, ... }:

let
  # zulu is java
  # todo: java?
  languages = with pkgs; [perl snobol4 ngn-k ghc rustup ruby_3_4 nodejs sbcl cabal-install lean4 uiua-unstable uiua386 zulu25 scryer-prolog swi-prolog racket];
  wmpackages = with pkgs; [agave ubuntu-sans alsa-utils xclip maim xidlehook liberation_ttf]; # for exwm setup
  editors = with pkgs; [ed emacs-gtk];
  utils = with pkgs; [unzip man-pages gnumake valgrind emscripten rlwrap wine nettools];
  tools = with pkgs; [ffmpeg imagemagick pdftk ghostscript gimp vlc scc zip xorg.xrandr gnuplot audacity typst garamond-libre blender devenv roboto comic-mono];
  discords = with pkgs; [webcord];
  iostools = with pkgs; [ifuse libimobiledevice jmtpfs fzf];
  misc = with pkgs; [neofetch figlet quickjs-ng curl autoconf platformio tinygo gdb minicom openocd usbutils musescore];
  school = with pkgs; [gh plantuml wireshark gpxsee dotnet-sdk_10 icu78 newcomputermodern dconf]; # dconf needed for gtk
in {
  home.packages = lib.lists.flatten [languages wmpackages editors utils tools discords iostools misc school];

  home.username = "gator";
  home.homeDirectory = "/home/gator";
  home.shell.enableShellIntegration = true;
  home.shell.enableBashIntegration = true;

  home.file = let
    # editable symlink
    link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/${path}";
  in {
    ".emacs.d".source = link ".emacs.d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv = { # https://nixos.asia/en/direnv
    enable = true;
    silent = true;
    mise.enable = false;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
