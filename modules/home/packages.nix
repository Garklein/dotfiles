{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    libtool # for vterm
    sops
    netcat
    openssh
    perl
    snobol4
    ngn-k
    ghc
    rustup
    ruby_3_4
    nodejs
    sbcl
    cabal-install
    lean4
    uiua-unstable
    uiua386
    zulu25
    scryer-prolog
    swi-prolog
    racket

    agave
    ubuntu-sans
    alsa-utils
    xclip
    maim
    xidlehook
    liberation_ttf
    caligula
    ed
    unzip
    man-pages
    gnumake
    valgrind
    emscripten
    rlwrap
    wine
    nettools
    ffmpeg
    imagemagick
    pdftk
    ghostscript
    gimp
    vlc
    scc
    zip
    xrandr
    gnuplot
    audacity
    typst
    garamond-libre
    blender
    roboto
    comic-mono
    webcord
    ifuse
    libimobiledevice
    fzf
    fastfetch
    figlet
    quickjs-ng
    curl
    autoconf
    tinygo
    gdb
    minicom
    openocd
    usbutils musescore
    gh
    plantuml
    gpxsee
    dotnet-sdk_10
    icu78
    newcomputermodern
    # emacs-gtk
  ]
  ++ lib.optionals config.gtk.enable [ pkgs.dconf ];
}
