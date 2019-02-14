#!/bin/zsh
make -C $i3 &
${XDG_CONFIG_HOME}/i3/negi3mods.py >> ~/tmp/negi3mods.log 2>&1 &
pkill -f 'mpc idle'
pkill sxhkd
sxhkd &
