#!/bin/zsh    
~/.config/i3/send circle next nwim
while ! xdotool search --all --classname '^nwim$'; do
    sleep 0.1
done
NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvr --remote-silent "$@"
