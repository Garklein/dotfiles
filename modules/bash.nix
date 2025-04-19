{ ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='\e[0;31m[\u@\h \W]$\e[m '
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
