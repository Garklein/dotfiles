{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.exwm = {
      enable = true;
      package = pkgs.emacs-gtk;
    };
    xkb = {
      layout = "us,ca";
      options = "grp:win_space_toggle";
    };
  };
}
