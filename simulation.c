#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM 5
#define MIN_THETA 0.0
#define MAX_THETA M_PI

double drandom(double min, double max);

int main(int argc, char *argv[ARG_NUM]) {
    double r, d, crit_angle;
    int n;
    unsigned int counts, i;;
    FILE *pf;

    srand(time(NULL));

    if (argc != ARG_NUM) {
        fprintf(stderr, "Usage: %s <path/to/file> <number of points> <radius> <distance>\n", argv[0]);
        return 1;
    }

    pf = fopen(argv[1], "w");
    n = atoi(argv[2]);
    r = atof(argv[3]);
    d = atof(argv[4]);

    if (n <= 0) {
        fprintf(stderr, "Number of points must be a positive integer.\n");
        return 1;
    }

    if (r <= 0 || d <= 0) {
        fprintf(stderr, "Radius and distance must be positive numbers.\n");
        return 1;
    }
    if (pf == NULL) {
        fprintf(stderr, "Could not create or open file at %s\n", argv[1]);
        return 1;
    }

    crit_angle = atan(r / d);
    printf("Critical angle: %f or %.2fpi\n", crit_angle, crit_angle / M_PI);

    
    if (pf != NULL) fclose(pf);
    return 0;
}

double drandom(double min, double max) {
    return min + (max - min) * ((double)rand() / RAND_MAX);
}