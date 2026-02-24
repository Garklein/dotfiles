{ pkgs, ... }: {
  home.packages = with pkgs; [ gh ];
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Garklein";
        email = "garklein97@gmail.com";
      };
      credential.helper = "/etc/profiles/per-user/gator/bin/gh auth git-credential";
    };
  };
}
