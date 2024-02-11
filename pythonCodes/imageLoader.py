import numpy as np
import cv2

def load_and_preprocess_image(image_path):
    image = cv2.imread(image_path) 
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) 
    return gray_image

image_path = 'ImageProcessing/in/image.png'
image = load_and_preprocess_image(image_path)
image = np.array(image)
image = np.round(image, 2)


f = open("ImageProcessing/in/imageArray.txt", "w")
f.write("4\n" + str(image.shape[0]) + "\n")
f.close()
f = open("ImageProcessing/in/imageArray.txt", "a")
np.savetxt(f, image, fmt ='%.0f')
f.write("3\n0 0.1 0 0.1 1 0.1 0 0.1 0\n8\n")
f.close()
