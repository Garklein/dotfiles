{ pkgs, ... }:

{
  xsession = {
    enable = true;
    windowManager.command = "emacs";
  };
}
