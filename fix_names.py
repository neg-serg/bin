#!/usr/bin/python3
""" Script to rename files to my own pretty naming format.

Usage:
    ./fix_names.py FILES ...
    ./fix_names.py -i FILES ...

Options:
    FILES   input file list
    -i      change file name, not print only.

Created by :: Neg
email :: <serg.zorg@gmail.com>
year :: 2020

"""

import os
import re
from docopt import docopt

from pretty_printer import pretty_printer

def fancy_name(filename):
    l = filename

    l = re.sub('[ _\t\.]+', "·", l)
    l = re.sub('·*-·*', '-', l)
    l = re.sub('\,[_-]', '-', l)
    l = re.sub('[+·\.]*-[+·\.]*', '-', l)
    l = re.sub('[+·\.]*:[+·\.]*', ':', l)

    l = re.sub('[><\\\]+', "", l)
    l = re.sub('\(+', "[", l)
    l = re.sub('\)+', "]", l)
    l = re.sub('[\'\`]', "=", l)
    l = re.sub('^[-.()+·\.]+', "", l)
    l = re.sub('[-.()+·\.]+$', "", l)

    return l

def main():
    cmd_args = docopt(__doc__, version='1.0')

    files =  cmd_args['FILES']
    file_rename = cmd_args['-i']

    for fname in files:
        if not (os.path.exists(fname) and os.path.isdir(fname)):
            break
        dir_name = os.path.dirname(fname)
        input_name = os.path.basename(fname)

        output_name = fancy_name(input_name)

        if file_rename:
            pref = dir_name + '/'
            os.rename(pref + input_name, pref + output_name)
        pp = pretty_printer
        print(
            f'{pp.prefix()}{pp.fancy_file(dir_name)} \
            \n{pp.fancy_file(input_name)} -> {pp.fancy_file(output_name)}'
        )

main()