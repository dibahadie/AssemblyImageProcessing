import numpy as np
import cv2

with open('ImageProcessing/out/resultArray.txt') as file:
    data_lines = file.readlines()

array2d = np.array([list(map(float, line.split())) for line in data_lines])

cv2.imwrite("ImageProcessing/out/image_processed.jpg", array2d)