#include <time.h>

clock_t begin, end;
time_t t;
    

void start_clock(){
    begin = clock();
}

double calculate_time_spent(){
    end = clock();
    double time_spent = (double)(end - begin) / (double) CLOCKS_PER_SEC;
    time(&t);

    FILE *fptr;
    fptr = fopen("TimeLog/timelog", "a");
    fprintf(fptr,"%sProcess finished in: %lf\n-----------------------------\n", ctime(&t), time_spent);
    fclose(fptr);
}