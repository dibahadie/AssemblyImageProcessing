// Diba Hadi
// Pr Jahangir
// Calculating execution time for assembly code
#include <time.h>

clock_t begin, end;
time_t t;
    

// starts the clock to calculate execution time
void start_clock(){
    begin = clock();
}

// ends the clock and logs the result
double calculate_time_spent(){
    // stopping the clock
    end = clock();
    // calculate time
    double time_spent = (double)(end - begin) / (double) CLOCKS_PER_SEC;
    // now time to log the results
    time(&t);

    FILE *fptr;
    // open the time log file
    fptr = fopen("TimeLog/timelog", "a");
    // write the results along with the time and date of the operetion
    fprintf(fptr,"%sProcess finished in: %lf\n-----------------------------\n", ctime(&t), time_spent);
    fclose(fptr);
}