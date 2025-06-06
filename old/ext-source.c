#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM     6
#define STRLEN      1024
#define DATA_PATH   "./tmp/out.txt"
#define IMAGE_PATH  "./tmp/image.png"
#define E0    -1
#define E1    1
#define E2    2
#define E3    3
#define EF    4
#define ER    5

typedef struct direction {
    double theta;
    double phi;
} direction;

typedef struct polar {
    double rho;
    double phi;
} polar;

int rand_dir(direction *dest) {
    if (dest == NULL) return -1;
    dest->theta = acos(1 - 2 * ((double)rand() / RAND_MAX));
    dest->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    return 0;
}

int rand_polar(polar *src, double max_rho) {
    if (src == NULL) {
        fprintf(stderr, "Error: argument is NULL.\n");
        return -1;
    }
    if (max_rho <= 0) {
        fprintf(stderr, "Error: max_rho must be greater than 0.\n");
        return -1;
    }
    src->rho = sqrt(((double)rand() / RAND_MAX) * (max_rho * max_rho));
    src->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    return 0;
}

int intcept(direction ray, double a, double b2, double r) {
    double a2, b, r2, tg, tg2, sf;

    if (ray.theta >= M_PI / 2) return 0;

    a2  = a * a;
    r2  = r * r;
    b   = sqrt(b2);
    tg  = sin(ray.theta) / cos(ray.theta);
    sf  = sin(ray.phi);
    tg2 = tg * tg;

    return ((a2 * tg2 - (2 * a * b* tg * sf) + b2 - r2) <= 0);
}

int myexit(int status, FILE *pf, char *buffer) {
    switch (status) {
        case E0:
            fprintf(stderr, "Usage: %s <n> <h> <d> <r> <R>\nWhere\n\tn: number of points to be generated (positive integer);\n\th: height of the detector (positive);\n\td: horizontal offset of the detector;\n\tr: radius of the source (non negative)\n\tR: radius of the detector (positive).\n", buffer);
            break;
        case E1:
            fprintf(stderr, "Error: number of points must be a positive integer.\n");
            break;
        case E2:
            fprintf(stderr, "Error: detector radius and height must be positive numbers.\n");
            break;
        case E3:
            fprintf(stderr, "Error: source radius must be a non-negative number.\n");
            break;
        case EF:
            fprintf(stderr, "Error: could not open output file.\n");
            break;
        case ER:
            fprintf(stderr, "Error: random number generation failed.\n");
            break;
    }

    if (pf != NULL) fclose(pf);
    return status;
}

int main(int argc, char *argv[ARG_NUM]) {
    double h, d, b2, r_src, r_det;
    int n, i, hits;
    char buffer[STRLEN];
    FILE *pf;
    direction ray;
    polar source;

    srand(time(NULL));
    pf = NULL;

    if (argc != ARG_NUM) return myexit(E0, pf, argv[0]);

    pf    = fopen(DATA_PATH, "w");
    n     = atoi(argv[1]);
    h     = atof(argv[2]);
    d     = atof(argv[3]);
    r_src = atof(argv[4]);
    r_det = atof(argv[5]);

    if (n <= 0)               return myexit(E1, pf, argv[0]);
    if (r_det <= 0 || h <= 0) return myexit(E2, pf, argv[0]);
    if (r_src < 0)            return myexit(E3, pf, argv[0]);
    if (pf == NULL)           return myexit(EF, pf, argv[0]);

    for (i = 0, hits = 0; i < n; i++) {
        if (rand_polar(&source, r_src)) return myexit(ER, pf, argv[0]);
        if (rand_dir(&ray))             return myexit(ER, pf, argv[0]);

        b2 = d * d + source.rho * source.rho - 2 * d * source.rho * sin(source.phi);

        if (intcept(ray, h, b2, r_det)) {
            hits++;
            fprintf(pf, "%f %f %f %f 1", source.rho, source.phi, ray.theta, ray.phi);
        } else {
            fprintf(pf, "%f %f %f %f 0", source.rho, source.phi, ray.theta, ray.phi);
        }
        if (i != n - 1) fprintf(pf, "\n");
    }

    fclose(pf);
    fprintf(stdout, "Ratio: %.6f\n", (double)hits / n);
    sprintf(buffer, "python3 plot.py %s %s", DATA_PATH, IMAGE_PATH);
    system(buffer);
    fprintf(stdout, "Image generated in %s\n", IMAGE_PATH);
    return 0;
}