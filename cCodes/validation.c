#include <string.h>
#include <stdlib.h>


int get_input_matrix_size() {
    printf("Please enter matrix size:\n");
    int matrix_size, isint;
    char line[256];
    while (1) {
        fgets(line, sizeof line, stdin);
        isint = sscanf(line, "%d", &matrix_size);
        if(isint && matrix_size <= 500) break;
        printf("%s", invalidInputError);
    }
    return matrix_size;
}
