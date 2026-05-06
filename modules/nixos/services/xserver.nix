{ pkgs, ... }:

{
  services.xserver = {
    # TODO remove greetd
    enable = true;
    displayManager.startx.enable = true; # for greetd
  };
}
