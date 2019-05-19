import os
import re
import subprocess
from colored import fg


class pretty_printer(object):
    def __init__(self):
        self.darkblue = fg(4)
        self.darkwhite = fg(7)
        self.darkgray = fg(237)
        self.cyberblue = fg(200)
        self.default = fg(0)

    # generic string wrapper
    def wrap(self, str):
        return self.darkblue + "⟬" + self.darkwhite + str + self.darkblue + "⟭"

    def size(self, sz):
        return self.wrap(
            self.darkwhite + "sz" + self.darkgray + "~" +
            self.darkwhite + str(sz)
        )

    def filelen(self, len):
        return self.wrap(
            self.darkwhite + "len" + self.darkgray + "=" +
            self.darkwhite + str(len)
        )

    def newfile(self, filename):
        return self.wrap(filename)

    def dir(self, filename):
        return self.wrap(filename)

    def prefix(self):
        return self.wrap(fg(25) + ">" + fg(26) + ">")

    def delim(self):
        return (self.cyberblue + self.default)

    # pretty printing for filename
    def fancy_file(self, filename):
        filename = re.sub('~', fg(2) + "~" + fg(7), filename)
        filename = re.sub(os.environ["HOME"], fg(2) + "~" + fg(7), filename)
        filename = re.sub("/", fg(4) + "/" + fg(7), filename)
        return self.wrap(filename)


# file info printer
class file_info_printer(object):
    def __init__(self):
        self.printer = pretty_printer()

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
            self.printer.prefix() +
            self.printer.fancy_file(filename) +
            self.printer.delim() +
            self.printer.newfile(filename)
        )

    def existsfile(self, filename):
        print(
            self.printer.prefix() +
            self.printer.fancy_file(filename) +
            self.printer.delim() +
            self.printer.size(os.stat(filename).st_size) +
            self.printer.delim() +
            self.printer.filelen(self.wccount(filename))
        )

    def currentdir(self, filename):
        print(
            self.printer.prefix() +
            self.printer.wrap("current dir") +
            self.printer.delim() +
            self.printer.dir(filename)
        )

    def dir(self, filename):
        print(
            self.printer.prefix() +
            self.printer.fancy_file(filename) +
            self.printer.delim() +
            self.printer.dir(filename)
        )

