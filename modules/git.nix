{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Garklein";
    userEmail = "garklein97@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.gh} auth git-credential";
    };
  };
}
