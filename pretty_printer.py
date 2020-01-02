import os
import re
import subprocess
from colored import fg


class pretty_printer():
    darkblue = fg(4)
    darkwhite = fg(7)
    darkgray = fg(237)
    cyberblue = fg(200)
    default = fg(0)

    @classmethod
    def wrap(cls, out):
        """ generic string wrapper """
        return cls.darkblue + "⟬" + cls.darkwhite + out + cls.darkblue + "⟭"

    @classmethod
    def size(cls, size):
        """ Print file size """
        return cls.wrap(
            cls.darkwhite + "sz" + cls.darkgray + "~" +
            cls.darkwhite + str(size)
        )

    @classmethod
    def filelen(cls, length):
        """ Print file line-length """
        return cls.wrap(
            cls.darkwhite + "len" + cls.darkgray + "=" +
            cls.darkwhite + str(length)
        )

    @classmethod
    def newfile(cls, filename):
        """ Print the new file """
        return cls.wrap(filename)

    @classmethod
    def dir(cls, filename):
        """ Print directory """
        return cls.wrap(filename)

    @classmethod
    def prefix(cls):
        """ Print prefix """
        return cls.wrap(fg(25) + ">" + fg(26) + ">")

    @classmethod
    def delim(cls):
        """ Print delimiter """
        return cls.cyberblue + cls.default

    @classmethod
    def fancy_file(cls, filename):
        """ Pretty printing for filename """
        filename = re.sub('~', fg(2) + "~" + fg(7), filename)
        filename = re.sub(os.environ["HOME"], fg(2) + "~" + fg(7), filename)
        filename = re.sub("/", fg(4) + "/" + fg(7), filename)
        return cls.wrap(filename)


# file info printer
class file_info_printer(object):
    def __init__(self):
        pass

    # counting with external wc is faster than everything else
    def wccount(self, filename):
        out = subprocess.Popen(
            ['wc', '-l', filename],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL
        ).communicate()[0]

        return int(out.partition(b' ')[0])

    def nonexistsfile(self, filename):
        print(
            pretty_printer.prefix() +
            pretty_printer.fancy_file(filename) +
            pretty_printer.delim() +
            pretty_printer.newfile(filename)
        )

    def existsfile(self, filename):
        print(
            pretty_printer.prefix() +
            pretty_printer.fancy_file(filename) +
            pretty_printer.delim() +
            pretty_printer.size(os.stat(filename).st_size) +
            pretty_printer.delim() +
            pretty_printer.filelen(self.wccount(filename))
        )

    def currentdir(self, filename):
        print(
            pretty_printer.prefix() +
            pretty_printer.wrap("current dir") +
            pretty_printer.delim() +
            pretty_printer.dir(filename)
        )

    def dir(self, filename):
        print(
            pretty_printer.prefix() +
            pretty_printer.fancy_file(filename) +
            pretty_printer.delim() +
            pretty_printer.dir(filename)
        )

