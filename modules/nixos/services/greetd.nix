{ config, pkgs, ... }:

{
  # make greetd load up exwm
  services.greetd = let
    tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  in {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} -c startx";
        user = "greeter";
      };
    };
  };
}
