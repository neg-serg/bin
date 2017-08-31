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
    want_payload=0
    def get_text(msg):
        text = ""
        if msg.is_multipart():
            html = None
            for part in msg.get_payload():
                if part.get_content_charset() is None:
                    charset = chardet.detect(str(part))['encoding']
                else:
                    charset = part.get_content_charset()
                if part.get_content_type() == 'text/plain':
                    text = decode_str(' '.join(part.get_payload().split('\n')) + "\n")
                if part.get_content_type() == 'text/html':
                    html = str(part.get_payload(decode=True),str(charset),"ignore")
            if html is None:
                return text.strip()
            else:
                msg_data = lxml.html.document_fromstring(html.strip())
                return str("\n".join(etree.XPath("//text()")(msg_data)))
        elif part.get_content_type() == 'text/plain':
            text = decode_str(' '.join(part.get_payload().split('\n')) + "\n")
            ret = "\n".join([ll.rstrip() for ll in text.splitlines() if ll.strip()])
            return ret.strip()

    def decode_str(string):
        return str(make_header(decode_header(string)))

    def decode_field(field):
        return decode_str(mail[field])

    fd = open(event.pathname, 'r')
    mail = MaildirMessage(message=fd)

    def highlight_(s, color_num=4):
        out = subprocess.Popen(
            ['xrq', 'color'+str(color_num)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        ).communicate()[0]
        color_=out.decode()[:-1]
        return "<span weight='bold' color='" + color_  +"'>" + s + "</span>"

    def wrap_(s, lhs=" ", rhs="  "):
        return highlight_(lhs) + s + highlight_(rhs) + highlight_("≫ ", color_num=2)

    From = wrap_("From") + decode_field('From') \
        .replace('<', '[') \
        .replace('>', ']')
    Subject = wrap_("Subject") + decode_field('Subject')
    Date = wrap_("Date") + decode_field('Date')

    Payload = ""
    if want_payload:
        Payload = "[Text]: " + get_text(mail)[0:2]
    mail_path = highlight_("new mail") + highlight_(" in ",color_num=2) + '/'.join(event.path.split('/')[-3:-1])
    if "INBOX" in mail_path:
        n = notify2.Notification(mail_path, From + "\n" +
                                Subject + Payload + "\n" + Date)
        n.set_icon_from_pixbuf(icon)
        n.set_timeout(12000)
        n.show()

    fd.close()

wm = pyinotify.WatchManager()
notifier = pyinotify.Notifier(wm, newfile)

for box in boxes:
    wm.add_watch(box+"/new", pyinotify.IN_CREATE | pyinotify.IN_MOVED_TO)

notifier.loop()
