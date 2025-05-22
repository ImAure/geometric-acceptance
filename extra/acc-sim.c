#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM 4

double ran_cos(void) { /* generate a random number in interval [1; -1] (intentionally flipped since \cos([0; \pi]) = [1; -1]) */
    return 1 - 2 * ((double)rand() / RAND_MAX);
}

int main(int argc, char *argv[ARG_NUM]) {
    double r, d, cos_theta, cos_theta_crit, ratio, expected_ratio, solid_angle, expected_solid_angle;
    int n;
    unsigned int hits, i;
    srand(time(NULL));

    if (argc != ARG_NUM) { /* check for correct number of arguments */
        fprintf(stderr, "Usage: %s <number of points> <radius> <distance>\n", argv[0]);
        return 1;
    }

    n = atoi(argv[1]);
    r = atof(argv[2]);
    d = atof(argv[3]);

    if (n <= 0) { /* check for correct input */
        fprintf(stderr, "Number of points must be a positive integer.\n");
        return 1;
    }
    if (r <= 0 || d <= 0) {
        fprintf(stderr, "Radius and distance must be positive numbers.\n");
        return 1;
    }
    
    cos_theta_crit = d / sqrt(r * r + d * d); /* cosine of critical angle */
    printf("Critical cos(theta): %f\n", cos_theta_crit);

    for (i = 0, hits = 0; i < n; i++) {
        cos_theta = ran_cos();              /* generate random cos(theta) */
        if (cos_theta > cos_theta_crit) {   /* check if point is inside acceptance cone */
            hits++;
        }
    }

    ratio = ((float)hits) / n;
    expected_ratio = 0.5 * (1 - cos_theta_crit);
    solid_angle = 4 * M_PI * ratio;         /* solid angle of acceptance cone */
    expected_solid_angle = 2 * M_PI * (1 - cos_theta_crit); /* expected solid angle */
    printf("Total points: %d\nTotal hits: %d\n", n, hits);
    printf("-------------------------------------------\n");
    printf("        \tratio\t\tsolid angle\n");
    printf("expected\t%f\t%f\n", expected_ratio, expected_solid_angle);
    printf("observed\t%f\t%f\n", ratio, solid_angle);
    printf("-------------------------------------------\n");

    return 0;
}