// Diba Hadi
// Pr. Jahangir
// Image processing part that's impelemented in c
// Mainly handling communication between assembly and python
// instruction to be printed in in the beginning
char intro_msg[] = "Welcome to image processing section. To process your image, please upload it in ImageProcessing/in under the name of image.jpg\n";


// prints the intro
int print_ip_intro() {
    printf("%s", intro_msg);
    // asks user if they want to proceed
    int program_type = get_yn();
    return program_type;
}


// image processing is ran by running convolution from this program
// inputs are given via terminal and from a file
// output is written in another file 
// the output file however contains some additional information and messages that are not needed
// this method cuts the unnecessary information
void crop_result_file() {
    // open the result
    FILE *fp = fopen("ImageProcessing/out/result.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return;
    }
    // define the lines we want
    int targetLineStart = 17;
    int targetLineEnd = 514;
    char line[10000];
    int currentLine = 1;
    // create another file to put the results in
    FILE *file = fopen("ImageProcessing/out/resultArray.txt", "w");

    // get each line and if the line counter is where we want write it in the second file
    while (fgets(line, sizeof(line), fp) != NULL) {
        if (currentLine >= targetLineStart && currentLine <= targetLineEnd) {
            // write in the second file
            fprintf(file, "%s", line);
        }
        // go to next line
        currentLine++;
    }
    // close the opened files
    fclose(file);
    fclose(fp);
    // remove the array created by imageLoader and results created by bash commands
    remove("ImageProcessing/out/result.txt");
    remove("ImageProcessing/in/imageArray.txt");
}

void run_image_processing_menu() {
    if (print_ip_intro()) {
        // load the image in python and create a 2d array from it
        // run the code at pythonCodes/imageLoader.py through terminal
        system("python3 pythonCodes/imageLoader.py");
        // inputs are given via terminal and from a file
        // output is written in another file 
        system("./run.sh ans < ImageProcessing/in/imageArray.txt > ImageProcessing/out/result.txt");
        // crop the unneeded lines from result
        crop_result_file();
        // convert the resulted array to an image using python libraries
        system("python3 pythonCodes/imageConverter.py");
        // remove the file containing the resulted array
        remove("ImageProcessing/out/resultArray.txt");
    }
}