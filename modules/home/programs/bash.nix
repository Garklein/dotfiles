{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1='[\t \W]$ '
    '';

    # https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login
    profileExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
         exec startx
       fi
     '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.aspire/bin"
  ];
}
