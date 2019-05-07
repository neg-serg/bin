#!/usr/bin/python3
import os
import subprocess
import random


class Wallpaper():
    def __init__(self):
        self.index = 0
        self.directory = os.path.expanduser('~/pic/wl')
        self.images = []
        self.get_wallpapers()
        self.random_selection = True

        # Random selection after reading all files
        if self.random_selection:
            self.index = random.randint(0, len(self.images) - 1)
        self.set_wallpaper()

    def get_path(self, file):
        return os.path.join(os.path.expanduser(self.directory), file)

    def get_wallpapers(self):
        try:
            # get path of all files in the directory
            self.images = list(
                filter(os.path.isfile,
                       map(self.get_path,
                           os.listdir(self.directory))))
        except(IOError):
            pass

    def set_wallpaper(self):
        if len(self.images) == 0:
            if self.wallpaper is None:
                self.text = "empty"
                return
            else:
                self.images.append(self.wallpaper)
        cur_image = self.images[self.index]
        subprocess.Popen(['hsetroot', '-full', cur_image])


if __name__ == '__main__':
    w = Wallpaper()
    w.set_wallpaper()

