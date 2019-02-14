#!/bin/zsh

export POLYBAR_INPUT_FORMAT="input:%{O5}%layout%"

export POLYBAR_MPD_FORMAT_PAUSED="%{F#395573}⟬%{O5}%{F#005f87}paused%{F#395573} %{F#395573}⟭" 
export POLYBAR_MPD_LEFT_SIDE="%{F#395573}⟬%{O5}%{F#005f87}〉%{F#005fd7}〉%{F#395573} %{F#ccc}"
export POLYBAR_MPD_SONG_TIME="%elapsed%%{F#395573}/%{F#ccc}%total%"
export POLYBAR_MPD_OFFLINE="%{F#395573}⟬%{O5}%{F#ccc}No MPD%{O5}%{F#395573}⟭ %{F#ccc}"
export POLYBAR_MPD_FORMAT_ONLINE="<label-song> <label-time>"

export POLYBAR_LL="%{F#395573}⟬%{F#ccc}"
export POLYBAR_RR="%{O5}%{F#395573}⟭%{F#ccc}"

case $1 in
    "hard")
        pkill polybar

        if [[ $(pgrep polybar|wc -l) -le 1  ]]; then
            polybar -c ${XDG_CONFIG_HOME}/polybar/main main &
        fi
    ;;
    "soft")
        polybar-msg cmd restart
    ;;
esac
