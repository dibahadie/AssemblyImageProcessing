#include <time.h>

clock_t begin, end, now;

void start_clock(){
    begin = clock();
}

double calculate_time_spent(){
    end = clock();
    double time_spent = (double)(end - begin) / (double)CLOCKS_PER_SEC;

    FILE *fptr;
    fptr = fopen("TimeLog/timelog", "w");
    fprintf(fptr, "%sProcess finished in: %lf\n-----------------------------\n", ctime(&now), time_spent);
    fclose(fptr);
}