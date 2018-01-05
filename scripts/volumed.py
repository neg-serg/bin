#!/usr/bin/env python3

""" volume manager
            _                          _
__   _____ | |_   _ _ __ ___   ___  __| |
\ \ / / _ \| | | | | '_ ` _ \ / _ \/ _` |
 \ V / (_) | | |_| | | | | | |  __/ (_| |
  \_/ \___/|_|\__,_|_| |_| |_|\___|\__,_|

Usage:
  volumed.py
  volumed.py run
  volumed.py ( + | - | --up | --down | --mute | --togmute | --unmute | --sync ) [value]

Options:
  run           # Run volume daemon.
  -h --help     # Show this screen.
  --version     # Show version.
  --up          # Set volume up
  --down        # Set volume down
  --togmute     # Toggle mute
  --mute        # Set mute
  --unmute      # Unset Mute
  --sync        # Sync Volume
  -v            # Verbose mode

Depends:
    pulsectl

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
from contextlib import contextmanager
import pulsectl

class VolumeDaemon():
    def __init__(self):
        self.inc=1
        self.maxvol=100
        self.current_volume=0

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
        self.mpd_connection=None

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
        # def queue(self, path):
        #     with connection():
        #         try:
        #             client.add(path)
        #         except mpd.CommandError:
        #             return 'invalid path'
        #     return 'queued'

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
        table={ "+" : " 0", "-" : " 9" }
        if arg in table.keys():
            cmd_=table[arg]
            ret=subprocess.Popen(
                shlex.split("xdotool key --window " + self.cwin + cmd_),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            ).communicate()[0].decode("utf-8").strip('\n')
        return ret

    def alsa_enabled(self):
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

    @contextmanager
    def mpd_make_connection(self):
        try:
            # use_unicode will enable the utf-8 mode for python2
            # see http://pythonhosted.org/python-mpd2/topics/advanced.html#unicode-handling
            self.mpd_client = mpd.MPDClient(use_unicode=True)
            self.mpd_client.connect(self.ip_default_addr, self.mpd_port)
        except OSError as err:
            if err.errno == 101:
                print("There is no mpd connection")
                self.mpd_status=False
                yield
        finally:
            self.mpd_client.close()
            self.mpd_client.disconnect()

    def run_daemon(self, args):
        volume_increment_step=1
        mpd_status=self.mpd_status()
        self.cwin=self.current_x11_window()

        print("mpd_status={}".format(mpd_status))

        # if mpd_status == "play":
        #     send_volume_inc_to_mpd()
        # elif self.cwin_is_mpv():
        #     if args[1] == "+" or args[1] == "-":
        #         self.mpv_change_vol_by_step(args[1])
        # else:
        #     self.mpv_change_vol_by_val(args[1])

    def run(self, args):
        if args['--up']:
            self.volume_up()
        elif args['--down']:
            self.volume_down()
        elif args['--mute']:
            self.volume_mute(True)
        elif args['--unmute']:
            self.volume_mute(False)
        elif args['--togmute']:
            self.toggle_mute()
        elif args['--sync']:
            self.volume_sync()
        elif args['run']:
            self.run_daemon(args)
        else:
            self.volume_manager()
        # print(args)

    def check_pulseaudio(self):
        return True

    def current_window_a_terminal(self):
        # xprop -id $(pfw) | grep -ow "${term_class}" | head -1) = "${term_class}"
        return True

    def start_pulsemixer_with_terminal(self):
        return subprocess.call(["st", "-e", "pulsemixer"])

    def start_pulsemixer(self):
        return subprocess.call("pulsemixer")

    def start_alsamixer_with_terminal(self):
        return subprocess.Popen(
            shlex.split(""" st alsamixer -g """),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0].decode("utf-8").strip('\n')

    def volume_manager(self):
        if self.current_window_a_terminal():
            print("current window is a terminal")
            self.start_pulsemixer()
        else:
            if self.check_pulseaudio():
                self.start_pulsemixer_with_terminal()
            else:
                self.start_alsamixer_with_terminal()

    def volume_up(self):
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

        self.get_current_volume()
        if self.capvol == 'yes':
            if self.current_volume <= 100 and self.current_volume >= self.limit:
                set_active_sink_to_100()
            elif self.current_volume < self.limit:
                set_pulseaudio_sink_volume(self.inc)
            elif self.current_volume <= self.maxvol and self.current_volume >= self.maxlimit:
                set_active_sink_to_max()
            elif self.current_volume < self.maxlimit:
                set_pulseaudio_sink_volume2(self.inc)
        self.get_current_volume()
        if self.autosync == 'yes':
            self.volume_sync()
        return True

    def volume_down(self):
        # pactl set-sink-volume ${active_sink} -self.inc + %; get_current_volume; [[ ${autosync} = 'yes' ]] && volume_sync
        return True

    def getSinkInputs(self):
        # inputs=$(pacmd list-sink-inputs |grep -B 4 'sink: '${1}' ' |awk '/index:/{print $2}' >${tmpfile})
        # input_array=$(cat ${tmpfile})
        return True

    def volume_sync(self):
        self.getSinkInputs()
        self.get_current_volume()
        # for each in ${input_array}; pactl set-sink-input-volume ${each} ${current_volume}%
        return True

    def get_current_volume(self):
        # current_volume=$(pacmd list-sinks \
        #     |grep -A 15 'index: '${active_sink}'' \
        #     |grep 'volume:' \
        #     |egrep -v 'base volume:' \
        #     |awk -F : '{print $3}' \
        #     |grep -o -P '.{0,3}%' \
        #     |sed s/.$// |tr -d ' ')
        return True

    def volume_mute(self, mute):
        ret=""
        if mute:
            #pactl set-sink-mute ${active_sink} 1; current_volume=0; status=1; ;;
            pass
        else:
            #pactl set-sink-mute ${active_sink} 0; get_current_volume; status=0; ;;
            pass
        return ret

    def toggle_mute(self):
        # volume_mute_status; [[ ${curStatus} == 'yes' ]] && { volume_mute unmute; exit 0; }; volume_mute mute ;;
        return True

    def volume_mute_status(self):
        # curStatus=$(pacmd list-sinks | grep -A 15 'index: '${active_sink}'' | awk '/muted/{ print $2}')
        return True

if __name__ == '__main__':
    v = VolumeDaemon()
    v.run(docopt(__doc__, version='0.1'))
