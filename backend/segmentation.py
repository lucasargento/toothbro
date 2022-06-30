from email.mime import base
from fastapi import File
from sympy import O
import torch
from PIL import Image
import time, os, base64


def get_yolov5():
    '''
    Loads the model for image recognition. Defines model confidence treshold for detection
    '''
    model = torch.hub.load('./yolov5', 'custom', path='./model/yolov5s.pt', source='local')  # local repo
    model.conf = 0.4
    return model

def get_image_from_bytes(binary_image, max_size=1024):
    '''
    Converts bytes to image and resizes it for it to be suitable for the model
    '''
    # create random name for image, image must be saved due to compatibilty issues with bytes from flutter. This is a temporary solution
    image_name = 'image_' + str(int(time.time())) + '.png'
    # open the image and resize it
    with open(image_name, "wb") as fh:
        fh.write(base64.decodebytes(binary_image))
    input_image = Image.open(image_name).convert("RGB")
    width, height = input_image.size
    resize_factor = min(max_size / width, max_size / height)
    resized_image = input_image.resize(
        (
            int(input_image.width * resize_factor),
            int(input_image.height * resize_factor),
        )
    )
    # delete the saved image after resizing
    os.remove(image_name)
    return resized_image
