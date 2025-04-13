{ ... }: {
  programs.git = {
    enable = true;
    userName = "Garklein";
    userEmail = "garklein97@gmail.com";
    config = {
      credential.helper = "libsecret";
    };
  };
}
