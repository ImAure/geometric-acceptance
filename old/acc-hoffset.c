#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM     5
#define LOG_PATH    "./tmp/acc-hoffset.log"

typedef struct direction {
    double theta;
    double phi;
} direction;

int rand_dir(direction *dest) {
    dest->theta = acos(1 - 2 * ((double)rand() / RAND_MAX));
    dest->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    return 0;
}

int intcept(direction ray, double a, double b, double r) {
    double a2, b2, r2, tg, tg2, sf;

    if (ray.theta >= M_PI / 2) return 0;

    a2  = a * a;
    b2  = b * b;
    r2  = r * r;
    tg  = sin(ray.theta) / cos(ray.theta);
    sf  = sin(ray.phi);
    tg2 = tg * tg;

    return ((a2 * tg2 - (2 * a * b* tg * sf) + b2 - r2) <= 0);
}

int main(int argc, char *argv[ARG_NUM]) {
    direction ray;
    double a, b, r;
    int n;
    unsigned int hits, i;
    FILE *log_file;

    srand(time(NULL));

    if (argc != ARG_NUM) {
        fprintf(stderr, "Usage: %s <N> <a> <b> <R>\nWhere\n\tN: number of points to be generated (positive integer);\n\ta: height of the detector (positive);\n\tb: horizontal offset of the detector;\n\tR: radius of the detector (positive).\n", argv[0]);
        return 1;
    }

    log_file = fopen(LOG_PATH, "w");
    n = atoi(argv[1]);
    a = atof(argv[2]);
    b = atof(argv[3]);
    r = atof(argv[4]);

    if (n <= 0) {
        fprintf(stderr, "Number of points must be a positive integer.\n");
        return 1;
    }
    if (r <= 0 || a <= 0) {
        fprintf(stderr, "Radius and height must be positive numbers.\n");
        return 1;
    }
    if (log_file == NULL) {
        fprintf(stderr, "Error opening log file.\n");
        return 1;
    }

    for (i = 0, hits = 0; i < n; i++) {
        rand_dir(&ray);
        if (intcept(ray, a, b, r)) {
            hits++;
            fprintf(log_file, "%f %f 1", ray.theta, ray.phi);
        } else {
            fprintf(log_file, "%f %f 0", ray.theta, ray.phi);
        }
        if (i != n - 1) fprintf(log_file, "\n");
    }
    
    fclose(log_file);
    printf("Ratio: %.6f\n", (double)hits / n);
    return 0;
}