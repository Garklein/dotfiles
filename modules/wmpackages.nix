# packages for my exwm setup
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    agave alsa-utils xclip maim xidlehook
  ];
}
