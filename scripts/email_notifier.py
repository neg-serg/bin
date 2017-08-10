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
            # text = str(msg.get_payload(decode=True),msg.get_content_charset(),'ignore')
            return ret.strip()

    def decode_str(string):
        return str(make_header(decode_header(string)))

    def decode_field(field):
        return decode_str(mail[field])

    fd = open(event.pathname, 'r')
    mail = MaildirMessage(message=fd)
    From = "[From]: " + decode_field('From')
    Subject = "[Subject]: " + decode_field('Subject')
    Date = "[Date]: " + decode_field('Date')
    Payload = ""
    if want_payload:
        Payload = "[Text]: " + get_text(mail)[0:2]
    n = notify2.Notification("New mail in " +
                             '/'.join(event.path.split('/')[-3:-1]), From + "\n" +
                             Subject + Payload + "\n" + Date)
    fd.close()

    n.set_icon_from_pixbuf(icon)
    n.set_timeout(12000)
    n.show()

wm = pyinotify.WatchManager()
notifier = pyinotify.Notifier(wm, newfile)

for box in boxes:
    wm.add_watch(box+"/new", pyinotify.IN_CREATE | pyinotify.IN_MOVED_TO)

notifier.loop()
