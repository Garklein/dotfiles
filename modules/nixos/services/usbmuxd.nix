{ pkgs, ... }:
{
  # mount ios devices
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
}
