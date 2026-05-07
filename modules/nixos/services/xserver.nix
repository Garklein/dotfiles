{ pkgs, ... }:

{
  # services.xserver.displayManager.startx = {
  #   enable = true;
  #   generateScript = true;
  # };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true; # for greetd
  };
}

# https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
# https://konfou.xyz/posts/nixos-without-display-manager/
# https://www.reddit.com/r/NixOS/comments/tjl2rr/no_keyboard_mouse_input_in_xorg/
# https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/configuration/x-windows.chapter.md#running-x-without-a-display-manager--sec-x11-startx
