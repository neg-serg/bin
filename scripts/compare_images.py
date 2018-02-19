#!/usr/sbin/python
try:
    from PIL import Image
    import imagehash

    h1 = imagehash.dhash(Image.open(sys.argv[1]))
    h2 = imagehash.dhash(Image.open(sys.argv[2]))

    print(h1 == h2)
except:
    print("False")
