char intro_msg[] = "Welcome to image processing section. To process your image, please upload it in ImageProcessing/in under the name of image.jpg\n";

int print_ip_intro() {
    printf("%s", intro_msg);
    int program_type = get_yn();
    return program_type;
}

void crop_result_file() {
    FILE *fp = fopen("ImageProcessing/out/result.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return;
    }
    int targetLineStart = 17;
    int targetLineEnd = 72;
    char line[10000];
    int currentLine = 1;
    FILE *file = fopen("ImageProcessing/out/resultArray.txt", "w");

    while (fgets(line, sizeof(line), fp) != NULL) {
        if (currentLine >= targetLineStart && currentLine <= targetLineEnd) {
            fprintf(file, "%s", line);
        }
        currentLine++;
    }
    fclose(file);
    fclose(fp);
    remove("ImageProcessing/out/result.txt");
    remove("ImageProcessing/in/imageArray.txt");
}

void run_image_processing_menu() {
    if (print_ip_intro()) {
        system("python3 pythonCodes/imageLoader.py");
        system("./run.sh ans < ImageProcessing/in/imageArray.txt > ImageProcessing/out/result.txt");
        crop_result_file();
        system("python3 pythonCodes/imageConverter.py");
        remove("ImageProcessing/out/resultArray.txt");
    }
}