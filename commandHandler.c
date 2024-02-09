#include <stdio.h>

char initialMessage[] = "Welcome to Matrix Multiplier.\nPlease choose your multiplication/Convolution method:\n1. Normal matrix multiplication (implemented by Assembly - without parallelism)\n2. Normal matrix multiplication (implemented by high level language - without parallelism)\n3. Normal matrix multiplication (implemented by assembly - using parallelism)\n4. Normal 2D convolution (implemented by assembly)\n5. Parallel 2D convolution (implemented by assembly)\n6. Normal 2D convolution (implemented by python)\n";
char invalidInputError[] = "Invalid input, please try again:\n";


int choose_program(){
    printf("%s", initialMessage);
    int program_type, isint;
    char line[256];
    while (1) {
        fgets(line, sizeof line, stdin);
        isint = sscanf(line, "%d", &program_type);
        if(isint && program_type <= 6) break;
        printf("%s", invalidInputError);
    }
    printf("---------------------------------------------------------------------------------------\n");
    return program_type;
}

int print_intro(int type){
    switch(type) {
        case 1:
            printf("Normal Matrix Multiplication: This method calculates the result by caclculating the dot product of each row and column from the first and second matrix corresponding to the index using assembly.\n");
            break;
        case 2:
            printf("Normal Matrix Multiplication: This method calculates the result by calculating the dot procuct of each row and column from the first and second matrix corresponding to the index using python.\n");
            break;
        case 3:
            printf("Parallel Matrix Multiplication: This method uses row-wise matrix multiplication and simd instructions to increase calculation speed by implementing parallelism.\n");
            break;
        case 4:
            printf("Normal Convolution Calculator: Calculating 2D convolution of two square matrices using assembly. This method does not use parallelism.\n");
            break;
        case 5:
            printf("Normal Convolution Calculator: Calculating 2D convolution of two square matrices using assembly. This method uses parallelism for better spead.\n");
            break;
        case 6:
            printf("Convolution Calculator: Calculating 2D convolution of two square matrices using python.\n");
            break;
    }
}