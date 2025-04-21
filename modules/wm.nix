# wm.nix: x server and exwm config

{ config, pkgs, lib, ... }:

let exwm-emacs = pkgs.emacs-gtk;
in {
  disabledModules = [ "services/x11/window-managers/exwm.nix" ];
  imports = [ /home/gator/nixpkgs/nixos/modules/services/x11/window-managers/exwm.nix ];
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
    # windowManager.session = lib.singleton {
    #   name = "exwm";
    #   start = "${exwm-emacs}/bin/emacs";
    # };
    windowManager.exwm = {
      enable = true;
      package = exwm-emacs;
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
      ExecStart = "${exwm-emacs}/bin/emacsclient -s /run/user/1000/emacs/server --eval \"(lock)\"";
    };
  };

  services.xserver.xkb = {
    layout = "us,ca";
    options = "grp:win_space_toggle";
  };

  # speed configured in exwm
  services.libinput = {
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "flat";
  };
}

