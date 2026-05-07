{ pkgs, ... }:

{
  xsession = {
    # enable = true;
    # windowManager.command = "${pkgs.emacs-gtk}/bin/emacs";
    windowManager.exwm = {
      enable = true;
      package = pkgs.emacs-gtk;
    };
  };
}
