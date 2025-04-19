{ ... }:

{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME";
      documents = "$HOME";
      download = "/tmp";
      music = "$HOME/bloat/music";
      pictures = "$HOME/keep/photos";
      videos = "$HOME/keep/photos";
    };
  };
}
