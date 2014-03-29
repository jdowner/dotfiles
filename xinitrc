#!/bin/bash
source /etc/profile

export LANG=en_US.utf8


if [ -x /usr/bin/urxvtd -a -z "$(pidof urxvtd)" ]; then
    urxvtd -q -f -o
fi

if [ -x /usr/bin/xscreensaver -a -z "$(pidof xscreensaver)" ]; then
    xscreensaver -no-splash &
fi

[ -f ~/.xrandr ] && xrandr $(<~/.xrandr)

exec /usr/bin/awesome 2> .xsession-errors

