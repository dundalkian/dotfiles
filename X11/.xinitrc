#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi


if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

#if [ -d /etc/X11/xinit/xinitrc.d ] ; then
# for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#  [ -x "$f" ] && . "$f"
# done
# unset f
#fi


# Saving a lot of the systemd startup commands for booting into graphical envrionment
# Assuming that at that point you intend to use the system for a while.
# On startup, wifi as well as other systemd services will not be active.

wpa_supplicant
netctl start wlp2s0-View-House

# Map capslock to escape and vice-versa
setxkbmap -option caps:swapescape
~/.fehbg & 
exec i3

# Restores last colorscheme
wal -R
