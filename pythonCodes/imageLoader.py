# Diba Hadi
# Pr Jahangir
# Convert image to array
import numpy as np
import cv2

# get an image path
# convert it to black and white so it's 2d
def load_and_preprocess_image(image_path):
    # read image from path
    image = cv2.imread(image_path) 
    # convert to black and white
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) 
    return gray_image

# path of image to be processed
image_path = 'ImageProcessing/in/image.jpg'
image = load_and_preprocess_image(image_path)
# convert image to a numpy array
image = np.array(image)
# round the image up to 2 decimal points
image = np.round(image, 2)


# open a file / create if doesn't exist / overwrite if exists
f = open("ImageProcessing/in/imageArray.txt", "w")
# write the commands needed for running a convolution
f.write("4\n" + str(image.shape[0]) + "\n")
f.close()
# open the same file in append mode
f = open("ImageProcessing/in/imageArray.txt", "a")
# append the input array as the first matrix
np.savetxt(f, image, fmt ='%.0f')
# append the kernel array and the exit code from program
f.write("3\n0 -1 0 -1 4 -1 0 -1 0\n8\n")
# close file
f.close()
