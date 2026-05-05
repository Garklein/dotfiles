{ config, pkgs, ... }:

{
  # make greetd load up exwm
  services.greetd = let
    tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
    xsessions = "${config.services.displayManager.sessionData.desktops}/share/xsessions";
  in {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} -x ${xsessions}";
        user = "greeter";
      };
    };
  };
}
