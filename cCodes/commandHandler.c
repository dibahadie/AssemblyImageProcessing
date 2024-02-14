// Diba Hadi
// Pr Jahangir
// validating inputs and getting program types
#include <stdio.h>

// instructions to be printed
char initialMessage[] = "Welcome to Matrix Multiplier.\nPlease choose your multiplication/Convolution method:\n1. Normal matrix multiplication (implemented by Assembly - without parallelism)\n2. Normal matrix multiplication (implemented by high level language - without parallelism)\n3. Normal matrix multiplication (implemented by assembly - using parallelism)\n4. Normal 2D convolution (implemented by assembly)\n5. Parallel 2D convolution (implemented by assembly)\n6. Normal 2D convolution (implemented by python)\n7. Image Processing Menu\n8. Exit\n";
char invalidInputError[] = "Invalid input, please try again:\n";


// gets and input from user between 1 to 8 and validates it
// gets input until input is valid
// returns the program type to be executed elsewhere
int choose_program(int program_number){
    printf("%s", initialMessage);
    int program_type, isint;
    char line[256];
    while (1) {
        // get a string form user
        fgets(line, sizeof line, stdin);
        // read an int from the string - returns 1 if successful
        isint = sscanf(line, "%d", &program_type);
        // check if input is a number and it's in the valid range (less than program numbers)
        if(isint && program_type <= program_number) break;
        // prints error and repeats the loop if condition is not satisfied
        printf("%s", invalidInputError);
    }
    printf("---------------------------------------------------------------------------------------\n");
    return program_type;
}

int get_yn(){
    // asks user if the photo is uploaded and should be processed
    printf("Proceed to next step? Y/N\n");
    int program_type;
    char c;
    char line[256];
    while (1) {
        // read a character and store in c
        c = getchar();
        // read an additional enter
        getchar();
        // if c is valid break
        if (c == 121 || c == 110) break;
        // if c is not valid get input again
        printf("%s", invalidInputError);
    }
    printf("---------------------------------------------------------------------------------------\n");
    // return if the user wants to proceed
    if (c == 121) program_type = 1;
    else program_type = 0;
    return program_type;
}


// prints a short intro for each program before getting the inputs in each one
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