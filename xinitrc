#!/bin/bash
source /etc/profile

export LANG=en_US.utf8
display=${DISPLAY#:}
display=${display%.*}

DISPLAY=:${display}.0 xsetroot -solid black
DISPLAY=:${display}.1 xsetroot -solid black
DISPLAY=:${display}.2 xsetroot -solid black
[ -f ~/.wallpaper-0 ] && DISPLAY=:0.0 feh --bg-scale $(<~/.wallpaper-0)
[ -f ~/.wallpaper-1 ] && DISPLAY=:0.1 feh --bg-scale $(<~/.wallpaper-1)
[ -f ~/.wallpaper-2 ] && DISPLAY=:0.2 feh --bg-scale $(<~/.wallpaper-2)

if [ -x /usr/bin/urxvtd -a -z "$(pidof urxvtd)" ]; then
    urxvtd -q -f -o
fi

if [ -x /usr/bin/xscreensaver -a -z "$(pidof xscreensaver)" ]; then
    xscreensaver -no-splash &
fi

[ -f ~/.xrandr ] && xrandr $(<~/.xrandr)

[ -x /usr/bin/xmodmap -a -f ${HOME}/.Xmodmap ] && xmodmap ${HOME}/.Xmodmap

[ -x /usr/bin/dispad ] && /usr/bin/dispad

exec /usr/bin/awesome 2> .xsession-errors

