{ pkgs, ... }: {
  home.packages = with pkgs; [ gh ];
  programs.git = {
    enable = true;
    userName = "Garklein";
    userEmail = "garklein97@gmail.com";
    extraConfig = {
      credential.helper = "/etc/profiles/per-user/gator/bin/gh auth git-credential";
    };
  };
}
