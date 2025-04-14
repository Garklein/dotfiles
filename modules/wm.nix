# wm.nix: x server and exwm config

{ config, pkgs, lib, ... }:

let emacs = pkgs.emacs-gtk;
in {
  # transparent emacs
  nixpkgs.overlays = [
    (final: prev: {
      emacs-gtk = prev.emacs-gtk.overrideAttrs (old: {
        patches = old.patches ++ [ ./../patches/borders-respect-alpha-background.patch ];
      });
    })
  ];

  # set up exwm
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.session = lib.singleton {
      name = "exwm";
      start = "${emacs}/bin/emacs";
    };
  };

  # make greetd load up exwm
  services.greetd = let
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    xsessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
  in {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} -x ${xsessions}";
        user = "greeter";
      };
    };
  };

  # set up cuendillar on sleep
  # this can't be done in home-manager since sleep.target can't be used by users
  systemd.services.cuendillar = {
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    description = "Lock screen on sleep";
    serviceConfig = {
      User = "gator";
      Type = "forking";
      ExecStart = "${emacs}/bin/emacsclient -s /run/user/1000/emacs/server --eval \"(lock)\"";
    };
  };

  # set the keyboard layout
  services.xserver.xkb = {
    layout = "us,ca";
    options = "grp:win_space_toggle";
  };
}
