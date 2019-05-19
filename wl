#!/usr/bin/python3
""" wallpaper script.

This script sets wallpaper and maintain wallpaper history.

Usage:
    ./wl [--list|--random|--show]

    --list          print list of wallpaper history.
    --random        set random picture as wallpaper.
    --show          open image viewer for the image history

Created by :: Neg
email :: <serg.zorg@gmail.com>
github :: https://github.com/neg-serg
year :: 2019

"""

import os
import errno
import subprocess
import random
from pathlib import Path

from docopt import docopt
from pretty_printer import pretty_printer


class wallpaper_manager():
    """ Set wallpaper """

    def __init__(self):
        self.directory = os.path.expanduser('~/pic/wl')
        self.history_size = 20

        self.images = []

        self.home = Path.home()

        self.get_wallpapers = self.get_wallpapers_with_posix_find
        self.get_wallpapers()

        self.random_selection = True

        wlist_dir = os.path.expanduser("~/.config/wall")
        self.wall_list_path = wlist_dir + '/' + "wallpaper.list"

        self.default_action = self.set_wallpaper

        try:
            os.makedirs(wlist_dir)
        except OSError as makedir_err:
            if makedir_err.errno != errno.EEXIST:
                raise

    def get_wallpapers_python_glob(self):
        """ Returns wallpaper list """
        # get path of all files in the directory
        self.images = Path(self.directory).glob('**/*')

    def get_wallpapers_with_posix_find(self):
        """ Use find Popen """
        proc = subprocess.Popen(
            ['find', self.directory, '-print0'],
            stdout=subprocess.PIPE
        )
        outs, _ = proc.communicate(timeout=15)
        self.images = str(outs).split('\\x00')

    def add_wall_history(self, image_path):
        """ Add wallpaper to the file with history """
        with open(self.wall_list_path, "a") as wall_list:
            wall_list.write(image_path + '\n')

    def get_wall_history(self):
        """ return wallpapers history """
        contents = Path(self.wall_list_path).read_text()
        return contents.strip().split('\n')

    def write_wall_history(self, hist_list):
        """ write wall history to file from list """
        with open(self.wall_list_path, "w") as wall_list:
            for wall in hist_list:
                wall_list.write(wall + '\n')

    def execute_hsetroot(self):
        """ Execute hsetroot to set wallpape """
        img_to_set = random.choice(self.images)
        subprocess.Popen(['hsetroot', '-full', img_to_set])
        return img_to_set

    def trim_history(self, wall_hist):
        """ Trim history to the given level """
        uniq_walls_in_hist = dict.fromkeys(wall_hist).keys()
        hist = list(uniq_walls_in_hist)[::-1]
        how_many = self.history_size
        trimmed_hist = hist[:how_many]
        return trimmed_hist

    def print_wall_history(self, history):
        """ Print wall history """
        home = str(self.home)
        for num, line in enumerate(history):
            if line.startswith(home):
                line = '~/' + line.split(home)[1]
                number = pretty_printer.wrap(str(num))
                file_name = pretty_printer.fancy_file(str(Path(line)))
                print(f'{number} {file_name}')

    def set_wallpaper(self):
        """ Set wallpaper """
        wall_img_path = self.execute_hsetroot()
        self.add_wall_history(wall_img_path)
        trimmed_hist = self.trim_history(self.get_wall_history())
        self.print_wall_history(trimmed_hist)
        self.write_wall_history(trimmed_hist)

    def print_wall_list(self):
        """ Only print wallpaper history """
        trimmed_hist = self.trim_history(self.get_wall_history())
        self.print_wall_history(trimmed_hist)

    def open_image_viewer(self):
        """ Open image viewer with wallpapers history """
        pass


def main():
    """ main function """
    wall_manager = wallpaper_manager()
    if cmd_args['--random']:
        wall_manager.set_wallpaper()
    elif cmd_args['--list']:
        wall_manager.print_wall_list()
    elif cmd_args['--show']:
        wall_manager.open_image_viewer()
    else:
        wall_manager.default_action()


if __name__ == '__main__':
    cmd_args = docopt(__doc__, version='0.8')
    main()

