#!/usr/bin/env python3

""" nwim runner

 _ ____      _(_)_ __ ___
| '_ \ \ /\ / / | '_ ` _ \
| | | \ V  V /| | | | | | |
|_| |_|\_/\_/ |_|_| |_| |_|

Usage:
  nwim.py

Options:
  -h --help     Show this screen.
  --version     Show version.
  --up)         Set volume up
  --down)       Set volume down
  --togmute)    Toggle mute
  --mute)       Set mute
  --unmute)     Unset Mute
  --sync)       Sync Volume

Created by :: Neg
email :: <serg.zorg@gmail.com>
github :: https://github.com/neg-serg?tab=repositories
year :: 2017

"""

from psutil import net_connections
import subprocess
import time
import os.path
import errno

import re

import shlex
from pathlib import Path

import sys
import docopt

class VolumeDaemon():
    def __init__(self):
        self.inc=1
        self.maxvol=100
        self.curVol=0

        self.mpv_socket="/tmp/mpv.socket"
        self.tmpfile='/tmp/pasink.tmp'

        self.capvol='no'
        self.autosync='yes'
        self.ip_default_addr="127.0.0.1"
        self.default_mpd_port="6600"

        self.active_sink=self.get_active_sink()
        self.limit=100 - self.inc
        self.maxlimit=self.maxvol - self.inc

        self.cwin=0
        self.term_class="st"

    def get_active_sink(self):
        return subprocess.Popen(
            shlex.split(""" pacmd list-sinks |awk '/* index:/{print $3}' """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def current_x11_window(self):
        return subprocess.Popen(
            shlex.split("pfw"),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def mpd_status(self):
        # mpd_status=$(grep 'state: ' <<< \
        #     $( \
        #         echo -ne "status\nclose\n" | \
        #         netcat "${addr_}" "${port_}" \
        #     ) \
        #     | awk '{print $2}'
        # )
        return True

    def send_volume_inc_to_mpd(self):
        # echo -ne "volume "$1"\nclose\n" | netcat "${addr_}" "${port_}"
        return True

    def cwin_is_mpv(self):
        return "mpv" == subprocess.Popen(
            shlex.split("xprop -id " + self.cwin + """ |rg WM_CLASS|awk -F ', ' '{print $2}'|tr -d '"' """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def mpv_change_vol_by_step(self, arg):
        ret = ""
        if arg == "-":
            ret=subprocess.Popen(
                shlex.split("xdotool key --window " + self.cwin + " "9""),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            ).communicate()[0].decode("utf-8").strip('\n')
        elif arg == "+":
            ret=subprocess.Popen(
                shlex.split("xdotool key --window " + self.cwin + " "0""),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            ).communicate()[0].decode("utf-8").strip('\n')
        return ret

    def alsa_enabled_or_not(self):
        return subprocess.Popen(
            shlex.split(""" amixer get Master | sed -n 's/^.*\[\(o[nf]\+\)]$/\1/p' | uniq """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def mpv_change_vol_by_val(self, value):
        return subprocess.Popen(
            shlex.split("mpvc -v " + value),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def run(self, args):
        def parse_args(args):
            # --up) volUp ;;
            # --down) volDown ;;
            # --togmute) volMuteStatus; [[ ${curStatus} == 'yes' ]] && { volMute unmute; exit 0; }; volMute mute ;;
            # --mute) volMute mute ;;
            # --unmute) volMute unmute ;;
            # --sync) volSync ;;
            if 2 + 2 == 5:
                print("lol")
            else:
                main(args)

        def main(args):
            if len(args) == 1:
                self.vol_manager()
            else:
                volume_increment_step=1
                mpd_status=self.mpd_status()
                self.cwin=self.current_x11_window()

                if mpd_status == "play":
                    send_volume_inc_to_mpd()
                elif cwin_is_mpv():
                    if args[1] == "+" or args[1] == "-"
                        mpv_change_vol_by_step(args[1])
                else:
                    mpv_chage_vol_by_val(args[1], args[2])

    def check_pulseaudio(self):
        return True

    def current_window_a_terminal(self):
        # xprop -id $(pfw) | grep -ow "${term_class}" | head -1) = "${term_class}"
        return True

    def start_pulsemixer_with_terminal(self):
        return subprocess.Popen(
            shlex.split(""" st pulsemixer """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def start_pulsemixer(self):
        return subprocess.Popen(
            shlex.split(""" pulsemixer """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def start_alsamixer_with_terminal(self):
        return subprocess.Popen(
            shlex.split(""" st alsamixer -g """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def vol_manager(self):
        self.pulseaudio_is_here=check_pulseaudio()
        if current_window_a_terminal():
            start_pulsemixer()
        else:
            if pulseaudio_is_here():
                start_pulsemixer_with_terminal()
            else:
                start_alsamixer_with_terminal()

    def volUp(self):
        def set_active_sink_to_100():
            return subprocess.Popen(
                shlex.split("pactl set-sink-volume " + self.active_sink +" -- 100% "),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            ).communicate()[0].decode("utf-8").strip('\n')

        def set_active_sink_to_max():
            # pactl set-sink-volume self.active_sink ${maxvol}%
            pass

        def set_pulseaudio_sink_volume(value):
            # pactl set-sink-volume self.active_sink -- +$value%
            pass

        def set_pulseaudio_sink_volume2(value)
            # pactl set-sink-volume self.active_sink +$value%
            pass

        self.getCurVol()
        if self.capvol == 'yes':
            if self.curVol <= 100 and self.curVol >= self.limit:
                set_active_sink_to_100()
            elif self.curVol < self.limit:
                set_pulseaudio_sink_volume(self.inc)
            elif self.curVol <= self.maxvol and self.curVol >= self.maxlimit:
                set_active_sink_to_max()
            elif self.curVol < self.maxlimit:
                set_pulseaudio_sink_volume2(self.inc)
        self.getCurVol()
        if self.autosync == 'yes':
            self.volSync()
        return True

    def volDown(self):
        # pactl set-sink-volume ${active_sink} -self.inc + %; getCurVol; [[ ${autosync} = 'yes' ]] && volSync
        return True

    def getSinkInputs(self):
        # inputs=$(pacmd list-sink-inputs |grep -B 4 'sink: '${1}' ' |awk '/index:/{print $2}' >${tmpfile})
        # input_array=$(cat ${tmpfile})
        return True

    def volSync(self):
        self.getSinkInputs()
        self.getCurVol()
        # for each in ${input_array}; pactl set-sink-input-volume ${each} ${curVol}%
        return True

    def getCurVol(self):
        # curVol=$(pacmd list-sinks \
        #     |grep -A 15 'index: '${active_sink}'' \
        #     |grep 'volume:' \
        #     |egrep -v 'base volume:' \
        #     |awk -F : '{print $3}' \
        #     |grep -o -P '.{0,3}%' \
        #     |sed s/.$// |tr -d ' ')
        return True

    def volMute(self, mute):
        ret=""
        if mute:
            #pactl set-sink-mute ${active_sink} 1; curVol=0; status=1; ;;
        else:
            #pactl set-sink-mute ${active_sink} 0; getCurVol; status=0; ;;
        return ret

    def toggle_mute(self):
        # volMuteStatus; [[ ${curStatus} == 'yes' ]] && { volMute unmute; exit 0; }; volMute mute ;;
        return True

    def volMuteStatus(self):
        # curStatus=$(pacmd list-sinks | grep -A 15 'index: '${active_sink}'' | awk '/muted/{ print $2}')

v=VolumeDaemon()
v.run(sys.argv)
