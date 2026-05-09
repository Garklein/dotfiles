{ config, username, ... }:
{
  # this can't be done in home-manager since sleep.target can't be used by users
  systemd.services.cuendillar = {
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    description = "Lock screen on sleep";
    serviceConfig = {
      User = username;
      Type = "forking";
      ExecStart = "/home/${username}/.nix-profile/bin/emacsclient -s /run/user/1000/emacs/server --eval \"(lock)\"";
    };
  };
}
