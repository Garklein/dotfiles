{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
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
    gpxsee
    dotnet-sdk_10
    icu78
    newcomputermodern
    # emacs-gtk
  ]
  ++ lib.optionals config.gtk.enable [ pkgs.dconf ]
  ++
  [
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
  ]
  ++ [
    tio
    SDL2 # for embedded TUI simulator
    espup
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
      package:
      with package;
      [
        dtc
        west
        tqdm
        cbor
        cbor2
        click
        patool
        jinja2
        anytree
        tkinter
        intelhex
        requests
        pyelftools
        jsonschema
        cryptography
      ]
      ++ [
        esptool
      ]
      ++ [
        pyusb
        pyserial
      ]
      ++ [
        semver
        pygments
        kconfiglib
      ]
      ++ [
        # NOTE: for west twister
        psutil
        pytest
        natsort
        tabulate # for --device-testing
        junitparser
      ]
    ))
  ]
    
  ++ [
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
  ++ [
    socat
    godot
    delve
    bashdb
    dts-lsp
    asm-lsp
    crates-lsp
    postgres-language-server
    # ============= 🤖 ==================
    tree
    pixi # multi-language package manager
    pnpm
    duckdb
    stylelint
    # vi-mongo  # mongodb tui
    # fritzing
    kubernetes-helm
    # =============
    ispell
    # kicad
    # logseq
    vips # dired image previews
    # openscad # FIXME: home-manager update
    mediainfo
    openscad-lsp
    imagemagick # for image-dired
    poppler-utils # dired pdf previews
    epub-thumbnailer # dired epub previews
    ffmpegthumbnailer
    
    # =============
    gnuplot
    shellcheck # shell script formatting
    octaveFull # gnu octave
    mermaid-cli # mermaid diagram support
    
    # ============= 🧑‍💻🐞✨‍ ================
    # tsui           # tailscale tui, not on nixpkgs yet | curl -fsSL https://neuralink.com/tsui/install.sh | bash
    pik # local port tui
    sops
    tgpt
    nmap
    lazyssh # ssh tui
    gpg-tui
    # termscp
    tcpdump
    cointop # crypto price feed
    caligula # disk imaging
    wiki-tui
    keymapviz # visualize keyboard layout in ascii
    bandwhich
    cargo-seek
    # leetcode-tui
    # keymap-drawer # visualize keyboard layout
    nvtopPackages.full # btop for gpu
    
    # gama-tui # github actions runners
    # codeberg-cli
    
    exercism
    presenterm
    wireshark-cli
    
    # ============= ‍❄🕸 ================
    nil # nix formatter
    # omnix
    devenv
    cachix
    nix-du # store visualizer
    # nix-ld      # run unpatched dynamic binaries
    nix-btm # nix process monitor
    nix-top # nix process visualizer
    nix-web # web gui
    nix-info
    # mcp-nixos
    nix-health # health check
    nix-inspect # flake explorer tui
    nix-weather # check binary cache availability
  ]
  ;
}
