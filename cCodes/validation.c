// Diba Hadi
// Pr Jahangir
// validatin input
#include <string.h>
#include <stdlib.h>


// get matrix size from user and validate it
// get input until it is valid
int get_input_matrix_size() {
    // prompt
    printf("Please enter matrix size:\n");
    int matrix_size, isint;
    char line[256];
    while (1) {
        // read a string
        fgets(line, sizeof line, stdin);
        // read an integer from the input string
        // returns 1 if successfull
        isint = sscanf(line, "%d", &matrix_size);
        // if size is valid and is integer break
        if(isint && matrix_size <= 500) break;
        // otherwise print errer message and get input again
        printf("%s", invalidInputError);
    }
    return matrix_size;
}
