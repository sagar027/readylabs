from __future__ import print_function
from PIL import Image, ImageOps
import os
import numpy as np
import cv2

desired_size = 500

image_dir = "eval"
for file in os.listdir(os.fsencode(image_dir)):
    #image = Image.open(image_dir + "/" + os.fsdecode(file)) #Linux
    image = Image.open(image_dir + "\\" + os.fsdecode(file)) #Windows
    old_size = image.size
    #Taking the max from height and width of the image and calculating ratio
    ratio = float(desired_size)/max(old_size)
    new_size = tuple([int(x*ratio) for x in old_size])

    image = image.resize(new_size, Image.ANTIALIAS)
    new_im = Image.new("RGB", (desired_size, desired_size), (255,255,255)) #creating RGB image and applying white mask
    new_im.paste(image, ((desired_size-new_size[0])//2, (desired_size-new_size[1])//2))
    cvimage = np.array(new_im)
    #cv2.imwrite(image_dir + "/500x500x3-" + os.fsdecode(file), cvimage) #Linux
    cv2.imwrite(image_dir + "\\500x500x3-" + os.fsdecode(file), cvimage) #Windows

