{
  pkgs,
  ...
}:

{
  # default cursor doesn't have clicky version with firefox
  home.pointerCursor = {
    name = "Quintom_Ink";
    package = pkgs.quintom-cursor-theme;
    size = 16;
  };
}
