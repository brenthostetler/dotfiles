#!/bin/sh

if [ -f "$HOME/.Xresources" ]; then
	xrdb -merge "$HOME/.Xresources"
fi

if [ -f "$HOME/.Xmodmap" ]; then
	xmodmap "$HOME/.Xmodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

compton --config "$HOME/.config/compton.conf"  &

#exec openbox-session
exec i3
