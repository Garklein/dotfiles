{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
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
    devenv
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
    platformio
    tinygo
    gdb
    minicom
    openocd
    usbutils musescore
    gh
    plantuml
    wireshark
    gpxsee
    dotnet-sdk_10
    icu78
    newcomputermodern
    # emacs-gtk
  ]
  ++ lib.optionals config.gtk.enable [ pkgs.dconf ]
  ++ [
    cmake
    ninja
    wget

        loco
        trunk
        libyaml
        binaryen
        rustywind
        dioxus-cli
        sea-orm-cli
        tailwindcss_4
        wasm-bindgen-cli
        rubyPackages_3_4.rails

        SDL2 # for embedded TUI simulator
        espup
        esptool
        esptool
        espflash
        esp-generate
        mcumgr-client
        cargo-embassy
        cargo-generate
        cargo-binstall
        renode-dts2repl
        kconfig-frontends

        (probe-rs-tools.overrideAttrs (old: {
          cargoBuildFeatures = (old.cargoBuildFeatures or [ ]) ++ [ "remote" ];
        }))

        (python314.withPackages (
          package: with package; [
            west
            tqdm
            cbor
            pyusb
            cbor2
            click
            semver
            patool
            jinja2
            anytree
            tkinter
            pygments
            pyserial
            intelhex
            requests
            kconfiglib
            pyelftools
            jsonschema
            cryptography
          ]
        ))

        llvm
        lldb
        ninja
        cmake
        ccache
        gnumake
        ldproxy
        openocd
        # avrdude
        dfu-util
        dfu-programmer
  ]
  ;
}
