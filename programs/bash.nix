{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='[\t \W]$ '
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.aspire/bin"
  ];
}
