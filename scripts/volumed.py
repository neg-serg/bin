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
        self.prev_volume=0

        self.tmpfsdir="/tmp/"
        self.mpv_socket=self.tmpfsdir + "mpv.socket"
        self.tmpfile=self.tempfsdir + 'pasink.tmp'

        self.capvol='no'
        self.autosync='yes'
        self.ip_default_addr="127.0.0.1"
        self.mpd_port="6600"

        self.active_sink=self.get_active_sink()
        self.limit=100 - self.inc
        self.maxlimit=self.maxvol - self.inc
        self.is_muted=False

        self.cwin=0x00000000
        self.term_class="st"
        self.mpd_client=None
        self.mpd_connection=None

        self.pulse=pulsectl.Pulse('volume-daemon')

    def make_pipe(self, str):
        return subprocess.Popen(
            shlex.split(str),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
        .communicate()[0].decode("utf-8").strip('\n')

    def get_active_sink(self):
        return make_pipe(""" pacmd list-sinks |awk '/* index:/{print $3}' """)

    def currX11win(self):
        return self.make_pipe("pfw")

    def mpd_status(self):
        if self.mpd_client is not None:
            return len(self.mpd_client.status()) > 0
        else:
            return False

    def change_mpd_volume(self):
        # echo -ne "volume "$1"\nclose\n" | netcat "${addr_}" "${port_}"
        return True

    def cwin_is_mpv(self):
        return "mpv" == self.make_pipe("xprop -id " + self.cwin + """ |rg WM_CLASS|awk -F ', ' '{print $2}'|tr -d '"' """)

    def mpv_change_vol_by_step(self, arg):
        ret = ""
        table={ "+" : " 0", "-" : " 9" }
        if arg in table.keys():
            cmd_=table[arg]
            ret=self.make_pipe("xdotool key --window " + self.cwin + cmd_)
        return ret

    def alsa_enabled(self):
        return self.make_pipe(""" amixer get Master | sed -n 's/^.*\[\(o[nf]\+\)]$/\1/p' | uniq """)

    def mpv_change_vol_by_val(self, value):
        return self.make_pipe("mpvc -v " + value)

    @contextmanager
    def mpd_make_connection(self):
        try:
            # use_unicode will enable the utf-8 mode for python2
            # see http://pythonhosted.org/python-mpd2/topics/advanced.html#unicode-handling
            self.mpd_client = mpd.MPDClient(use_unicode=True)
            self.mpd_client.connect(self.ip_default_addr, self.mpd_port)
            yield
        except OSError as err:
            if err.errno == 101:
                print("There is no mpd connection")
                yield
        finally:
            self.mpd_client.close()
            self.mpd_client.disconnect()

    def exec_cmd(self, callback, args):
        with self.mpd_make_connection():
            self.cwin=self.currX11win()
            if args is not None:
                callback(args)
            else:
                callback()

    def daemon(self, args):
        # def queue(self, path):
        #     with connection():
        #         try:
        #             client.add(path)
        #         except mpd.CommandError:
        #             return 'invalid path'
        #     return 'queued'


        # if mpd_state == "play":
        #     send_volume_inc_to_mpd()
        # elif self.cwin_is_mpv():
        #     if args[1] == "+" or args[1] == "-":
        #         self.mpv_change_vol_by_step(args[1])
        # else:
        #     self.mpv_change_vol_by_val(args[1])
        pass

    def run(self, args):
        print(args)
        if args['--up']:
            self.exec_cmd(self.volume_up)
        elif args['--down']:
            self.exec_cmd(self.volume_down)
        elif args['--mute']:
            self.exec_cmd(self.volume_mute, True)
        elif args['--unmute']:
            self.exec_cmd(self.volume_mute, False)
        elif args['--togmute']:
            self.exec_cmd(self.toggle_mute)
        elif args['--sync']:
            self.exec_cmd(self.volume_sync)
        elif args['run']:
            self.daemon(args)
        else:
            self.volume_manager()

    def check_pulseaudio(self):
        return True

    def current_window_a_terminal(self):
        # xprop -id $(pfw) | grep -ow "${term_class}" | head -1) = "${term_class}"
        return True

    def start_pulsemixer(self, with_terminal=False):
        if not with_terminal:
            return subprocess.call("pulsemixer")
        else:
            return subprocess.call(["st", "-e", "pulsemixer"])

    def start_alsamixer(self):
        if not with_terminal:
            return subprocess.call("alsamixer")
        else:
            return subprocess.call(["st", "-e", "alsamixer"])

    def volume_manager(self):
        if self.check_pulseaudio():
            self.start_pulsemixer(self.current_window_a_terminal())
        else:
            self.start_alsamixer(self.current_window_a_terminal())

    def set_active_sink_to_100(self):
        return self.make_pipe("pactl set-sink-volume " + self.active_sink +" -- 100% ")

    def set_active_sink_to_max(self):
        return self.make_pipe("pactl set-sink-volume " + self.active_sink +" " + self.maxvol)

    def set_pulseaudio_sink_volume(self, value):
        return self.make_pipe("pactl set-sink-volume " + self.active_sink +" " + "+" + value + "%")

    def volume_up(self):
        self.get_current_volume()
        if self.capvol == 'yes':
            if self.current_volume <= 100 and self.current_volume >= self.limit:
                self.set_active_sink_to_100()
            elif self.current_volume < self.limit:
                self.set_pulseaudio_sink_volume(self.inc)
            elif self.current_volume <= self.maxvol and self.current_volume >= self.maxlimit:
                self.set_active_sink_to_max()
            elif self.current_volume < self.maxlimit:
                self.set_pulseaudio_sink_volume(self.inc)
        self.get_current_volume()
        if self.autosync == 'yes':
            self.volume_sync()
        return True

    def volume_down(self):
        # pactl set-sink-volume ${active_sink} -self.inc + %; get_current_volume; [[ ${autosync} = 'yes' ]] && volume_sync
        return True

    def get_sink_inputs(self):
        return self.pulse.sink_input_list()

    def volume_sync(self):
        self.get_sink_inputs()
        volume=self.get_current_volume()
        for sink in get_sink_inputs():
            self.pulse.sink_input_volume_set(sink.index, volume)

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
            pactl set-sink-mute ${active_sink} 1;
            self.current_volume=0
            self.is_muted=1
        else:
            #pactl set-sink-mute ${active_sink} 0; get_current_volume; status=0; ;;
            self.current_volume=self.prev_volume
            self.is_muted=0
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
