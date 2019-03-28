#!/bin/zsh
make -C ${XDG_CONFIG_HOME}/i3/ &
${XDG_CONFIG_HOME}/i3/negi3mods.py >> ${HOME}/tmp/negi3mods.log 2>&1 &
pkill -f 'mpc idle'
pkill sxhkd; sxhkd &
~/bin/scripts/panel_run.sh hard
