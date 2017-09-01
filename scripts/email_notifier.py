#!/usr/bin/env python3

import pyinotify
import notify2
from os.path import expanduser
from mailbox import MaildirMessage
from email.header import Header, decode_header, make_header
import re

import gi; gi.require_version('GdkPixbuf', '2.0')
from gi.repository import GdkPixbuf

import lxml.html
from lxml import etree

import subprocess

# Getting the path of all the boxes
with open(expanduser("~/.mutt/mailboxes"), 'r') as fd:
    boxes=[expanduser(f[1:-1]) for f in re.findall('"[^"]+"', fd.readline()[10:])]

notify2.init('email_notifier.py')

# Handling a new mail
icon = GdkPixbuf.Pixbuf.new_from_file("/usr/share/icons/Lüv/actions/24/mail-mark-unread-new.svg")

def newfile(event):
    def decode_str(string):
        return str(make_header(decode_header(string)))

    def decode_field(field):
        return decode_str(mail[field])

    fd = open(event.pathname, 'r')
    mail = MaildirMessage(message=fd)

    def hi_(s, color_num=4):
        out = subprocess.Popen(
            ['xrq', 'color'+str(color_num)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0]
        color_=out.decode()[:-1]
        return "<span weight='bold' color='" + color_  +"'>" + s + "</span>"

    def wrap_(s, lhs=" ", rhs="  "):
        return hi_(lhs) + s + hi_(rhs) + hi_("≫ ", color_num=2)

    from_data = decode_field('From') \
        .replace('<', '[') \
        .replace('>', ']') \
        .replace('[', hi_('[')) \
        .replace(']', hi_(']'))
        .replace('@', hi_(']',color_num=2))
    From = wrap_("From") + from_data
    Subject = wrap_("Subject") + decode_field('Subject')
    Date = wrap_("Date") + decode_field('Date')

    mail_path = hi_("New mail", color_num=6) + \
        hi_(" in ",color_num=2) + \
        hi_('/',color_num=2).join(event.path.split('/')[-3:-1])
    if "INBOX" in mail_path:
        n = notify2.Notification(mail_path, From + "\n" +
                                Subject + Date)
        n.set_icon_from_pixbuf(icon)
        n.set_timeout(12 * 1000)
        n.show()

    fd.close()

wm = pyinotify.WatchManager()
notifier = pyinotify.Notifier(wm, newfile)

for box in boxes:
    wm.add_watch(box+"/new", pyinotify.IN_CREATE | pyinotify.IN_MOVED_TO)

notifier.loop()
