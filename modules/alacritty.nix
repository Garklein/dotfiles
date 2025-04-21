{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 7;

        normal = {
          family = "agave";
          style = "Regular";
        };
        bold = {
          family = "agave";
          style = "Bold";
        };
        italic = {
          family = "agave";
          style = "Italic";
        };
        bold_italic = {
          family = "agave";
            style = "Bold_Italic";
        };
      };

      colors = {
        normal = {
          black = "#000000";
          blue = "#52b7ff";
          cyan = "#61d6b9";
          green = "#11a10e";
          magenta = "#9016b5";
          red = "#ff3636";
          white = "#e8e8e8";
          yellow = "#f1fa8c";
        };
        bright = {
          black = "#000000";
          blue = "#52b7ff";
          cyan = "#61d6b9";
          green = "#11a10e";
          magenta = "#9016b5";
          red = "#ff3636";
          white = "#e8e8e8";
          yellow = "#f1fa8c";
        };
        primary = {
          background = "#0c0c0c";
          foreground = "#f3f3f3";
        };
      };
    };
  };
}
