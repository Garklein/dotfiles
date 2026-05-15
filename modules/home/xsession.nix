{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.exwm = {
      enable = true;
      package = pkgs.emacs-gtk;
    };
  };
}
