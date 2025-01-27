import numpy as np
import itertools as it
from PIL import Image
from pathlib import Path

key = np.asarray(Image.open('./CharacterMapKey.png'))

def map_color(x_t:int,y_t:int, target_color, mapped_array:np.ndarray, raw_array:np.ndarray):
    #raw_array[color]
    for x,y in it.product(range(raw_array.shape[0]),range(raw_array.shape[1])):
        color = raw_array[x,y,:] #color of the pixel at x,y
        if (color == target_color)[:3].all():
                #color matches
                #use red channel for skin x coordinate
                mapped_array[x,y,0] = x_t
                #use green channel for skin y coordinate
                mapped_array[x,y,1] = y_t
                #nothing for blue channel
                mapped_array[x,y,2] = 0
                #use both transparencies of skin and animation
                #255 * (1 - (1 - alpha_a / 255) * (1 - alpha_b / 255))
                mapped_array[x,y,3] = int(255 * (1 - (1 - color[3] / 255.0) * (1 - target_color[3] / 255.0)))

def map_image(raw_array:np.ndarray)-> np.ndarray:
    mapped_array = np.zeros_like(raw_array)
    #for every color in the key replace that color in the raw image with the position of that color in the key
    for x, line in enumerate(key):
        if (line == 0).all(): continue
        for y, color in enumerate(line):
            #skip over completely transparent pixels
            if color[3] == 0: continue
            #x and y position of key color and the color itself
            map_color(x,y,color, mapped_array, raw_array)
    return mapped_array

for path in list(Path("./raw").glob('*.png')):
    raw_array = np.asarray(Image.open(path))
    mapped_array = map_image(raw_array)
    mapped_image = Image.fromarray(mapped_array)
    mapped_image.save('./mapped/mapped_' + path.name)
