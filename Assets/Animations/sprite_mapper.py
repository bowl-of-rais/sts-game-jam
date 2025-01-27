import numpy as np
from PIL import Image
from pathlib import Path

raw_array = None
mapped_array = None
key = np.asarray(Image.open('./CharacterMapKey.png'))

def map_color(x_t:int,y_t:int, target_color):
    #raw_array[color]
    for x, line in enumerate(raw_array):
        for y, color in enumerate(line):
            if (color == target_color)[:3].all():
                #use red channel for skin x coordinate
                mapped_array[0] = x_t
                #use green channel for skin y coordinate
                mapped_array[1] = y_t
                #nothing for blue channel
                mapped_array[2] = 0
                #use both transparencies of skin and animation
                #255 * (1 - (1 - alpha_a / 255) * (1 - alpha_b / 255))
                mapped_array[3] = 255 * (1 - (1 - raw_array[x,y,3] / 255) * (1 - target_color[3] / 255))

def map_image(raw_array: np.ndarray):
    for x, line in enumerate(key):
        for y, color in enumerate(line):
            #skip over completely transparent pixels
            if color[3] == 0: break
            map_color(x,y,color)
    return mapped_array

for path in list(Path("./raw").glob('*.png')):
    raw_array = np.asarray(Image.open(path))
    mapped_array = np.ndarray(raw_array.shape, np.uint8)
    mapped_array = map_image(raw_array)
    mapped_image = Image.fromarray(mapped_array)
    mapped_image.save('./mapped/mapped_' + path.name)
