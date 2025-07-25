{ ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='\e[0;31m[\u@\h \W]$\e[m '
      [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
        source "$EAT_SHELL_INTEGRATION_DIR/bash"
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
