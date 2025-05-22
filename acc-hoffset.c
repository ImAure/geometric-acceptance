#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM 5

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
    double a2, b2, r2, d2, ba, ba2, st, ct, sf, st2, ct2, sf2;
    if (a == 0) {
        return 0;
    }
    a2  = a * a;
    b2  = b * b;
    r2  = r * r;
    d2  = a2 + b2;
    ba  = b / a;
    ba2 = ba * ba;
    st  = sin(ray.theta);
    ct  = cos(ray.theta);
    sf  = sin(ray.phi);
    st2 = st * st;
    ct2 = ct * ct;
    sf2 = sf * sf;

    return ((d2 * st2 - r2 * ct2 + ba2 * sf2 * (d2 - r2) + 2 * r2 * ba * sf * st * ct) <= 0); 
}

int main(int argc, char *argv[ARG_NUM]) {
    direction ray;
    double a, b, r;
    int n;
    unsigned int hits, i;

    srand(time(NULL));

    if (argc != ARG_NUM) {
        fprintf(stderr, "Usage: %s <N> <a> <b> <R>\nWhere\n\tN: number of points to be generated (positive integer);\n\ta: height of the detector (positive);\n\tb: horizontal offset of the detector;\n\tR: radius of the detector (positive).\n", argv[0]);
        return 1;
    }
    
    n = atoi(argv[1]);
    a = atof(argv[2]);
    b = atof(argv[3]);
    r = atof(argv[4]);

    if (n <= 0) {
        fprintf(stderr, "Number of points must be a positive integer.\n");
        return 1;
    }
    if (r <= 0 || a <= 0) {
        fprintf(stderr, "Radius and distance must be positive numbers.\n");
        return 1;
    }
    for (i = 0, hits = 0; i < n; i++) {
        rand_dir(&ray);
        if (intcept(ray, a, b, r)) hits++;
    }

    printf("Ratio: %.6f\n", (double)hits / (2 * n));
    return 0;
}

