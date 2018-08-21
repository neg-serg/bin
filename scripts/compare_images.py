#!/usr/sbin/python
from PIL import Image
from imagehash import dhash
import sys

print(
    dhash(Image.open(sys.argv[1])) == dhash(Image.open(sys.argv[2]))
)

