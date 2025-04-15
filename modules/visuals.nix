# misc visuals
{ pkgs, ... }:

{
  # get that sweet sweet transparency
  services.picom.enable = true;

  # make toolbars dark theme
  home.packages = [ pkgs.dconf ]; # needed for gtk
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  # default cursor doesn't have clicky version with firefox
  home.pointerCursor = {
    name = "Quintom_Ink";
    package = pkgs.quintom-cursor-theme;
    size = 16;
  };
}
