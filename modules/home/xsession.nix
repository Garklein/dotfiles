{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.command = "${pkgs.emacs-gtk}/bin/emacs";
  };
}
