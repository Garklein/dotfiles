picom --backend xrender &
~/bin/lemonbar.sh | lemonbar-xft -B "#00f1ddc2" -F "#463541" &
xclock -g 75x75-0+0 -bg "#f5e4c8" &
xbacklight -set 20 &
feh --bg-fill ~/dormant/wallpaper.jpg &
cwm
