#!/usr/bin/env python3

""" volume manager
            _                          _
__   _____ | |_   _ _ __ ___   ___  __| |
\ \ / / _ \| | | | | '_ ` _ \ / _ \/ _` |
 \ V / (_) | | |_| | | | | | |  __/ (_| |
  \_/ \___/|_|\__,_|_| |_| |_|\___|\__,_|

Usage:
  vold.py run
  vold.py (--up | --down | --mute | --togmute | --unmute | --sync) [value]

Options:
  run           # Run volume daemon
  -h --help     # Show this screen.
  --version     # Show version.
  --up          # Set volume up
  --down        # Set volume down
  --togmute     # Toggle mute
  --mute        # Set mute
  --unmute      # Unset Mute
  --sync        # Sync Volume
  -v            # Verbose mode

Created by :: Neg
email :: <serg.zorg@gmail.com>
github :: https://github.com/neg-serg?tab=repositories
year :: 2018

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
from docopt import docopt

import mpd

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
        self.mpd_port="6600"

        self.active_sink=self.get_active_sink()
        self.limit=100 - self.inc
        self.maxlimit=self.maxvol - self.inc

        self.cwin=0
        self.term_class="st"
        self.mpd_client=None

        try:
            # use_unicode will enable the utf-8 mode for python2
            # see http://pythonhosted.org/python-mpd2/topics/advanced.html#unicode-handling
            client = mpd.MPDClient(use_unicode=True)
            client.connect(self.ip_default_addr, self.mpd_port)
        except OSError as err:
            if err.errno == 101:
                print("There is no mpd connection")
                self.mpd_status=False
            else:
                self.mpd_client=client
            pass

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
        if self.mpd_client is not None:
            return len(self.mpd_client.status()) > 0
        else:
            return False

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
                shlex.split("xdotool key --window " + self.cwin + " \"9\""),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            ).communicate()[0].decode("utf-8").strip('\n')
        elif arg == "+":
            ret=subprocess.Popen(
                shlex.split("xdotool key --window " + self.cwin + " \"0\""),
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
        def main(args):
            if len(args) == 1:
                self.vol_manager()
            else:
                volume_increment_step=1
                mpd_status=self.mpd_status()
                self.cwin=self.current_x11_window()

                if mpd_status == "play":
                    send_volume_inc_to_mpd()
                elif self.cwin_is_mpv():
                    if args[1] == "+" or args[1] == "-":
                        self.mpv_change_vol_by_step(args[1])
                else:
                    self.mpv_change_vol_by_val(args[1])

        print(args)
        # --up) volUp ;;
        # --down) volDown ;;
        # --togmute) volMuteStatus; [[ ${curStatus} == 'yes' ]] && { volMute unmute; exit 0; }; volMute mute ;;
        # --mute) volMute mute ;;
        # --unmute) volMute unmute ;;
        # --sync) volSync ;;
        main(args)

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
        self.pulseaudio_is_here=self.check_pulseaudio()
        if self.current_window_a_terminal():
            self.start_pulsemixer()
        else:
            if pulseaudio_is_here():
                self.start_pulsemixer_with_terminal()
            else:
                self.start_alsamixer_with_terminal()

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

        def set_pulseaudio_sink_volume2(value):
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
            pass
        else:
            #pactl set-sink-mute ${active_sink} 0; getCurVol; status=0; ;;
            pass
        return ret

    def toggle_mute(self):
        # volMuteStatus; [[ ${curStatus} == 'yes' ]] && { volMute unmute; exit 0; }; volMute mute ;;
        return True

    def volMuteStatus(self):
        # curStatus=$(pacmd list-sinks | grep -A 15 'index: '${active_sink}'' | awk '/muted/{ print $2}')
        return True

if __name__ == '__main__':
    v = VolumeDaemon()
    v.run(docopt(__doc__, version='0.1'))
