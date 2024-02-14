# Diba Hadi
# Pr Jahangir
# Converting processed array to image
import numpy as np
import cv2

# open the file containing the array on which convolution has been executed
with open('ImageProcessing/out/resultArray.txt') as file:
    data_lines = file.readlines()

# convert the read lines to a numpy array
array2d = np.array([list(map(float, line.split())) for line in data_lines])

# create an image out of the numpy array given and store it in the given address
cv2.imwrite("ImageProcessing/out/image_processed.jpg", array2d)