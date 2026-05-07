{ username, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Garklein";
        email = "garklein97@gmail.com";
      };
      credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
    };
  };
}
