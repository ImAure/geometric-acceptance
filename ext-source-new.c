#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define DATA_PATH "./tmp/out.txt"
#define ARG_NUM   5

#define HIT         " 1"
#define MISS        " 0"

#define ERR_ARGC    -1
#define ERR_FILE    -2
#define ERR_NEG_NUM  1
#define ERR_SRC_RAD  2
#define ERR_DTC      3
#define ERR_RAND     4

typedef struct _dir3D {
    double theta;
    double phi;
} dir3D_t;

typedef struct _polar2D {
    double rho;
    double phi;
} polar2D_t;

int rand_dir3D_gen(dir3D_t *ptr) {
    if (ptr == NULL) return -1;
    ptr->theta = acos(1 - 2 * ((double)rand() / RAND_MAX));
    ptr->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    return 0;
}

int rand_polar2D_gen(polar2D_t *ptr, double max_rho){
    if ((ptr == NULL) || (max_rho < 0)) return -1;
    if (max_rho < 0) {
        ptr->rho = 0;
        prt->phi = 0;
    } else {
        ptr->rho = sqrt(((double)rand() / RAND_MAX) * (max_rho * max_rho));
        ptr->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    }
    return 0;
}

int intcept(void) {}

int myexit(int status, FILE *pf, char *string) {
    (void)fprintf(stderr, "An error occurred in executing '%s':\n", string);
    switch (status) {
        case ERR_ARGC:
            (void)fprintf(stderr, "Usage: %s <n> <r> <h> <d> <R>\nWhere\n", string);
            (void)fprintf(stderr, "\tn: number of points to be generated (positive integer);\n");
            (void)fprintf(stderr, "\tr: radius of the source (cm, non negative)\n");
            (void)fprintf(stderr, "\th: height of the detector (cm, positive);\n");
            (void)fprintf(stderr, "\td: horizontal offset of the detector (cm);\n");
            (void)fprintf(stderr, "\tR: radius of the detector (positive).\n");
            break;
        case ERR_NEG_NUM:
            (void)fprintf(stderr, "Number of points must be a positive integer.\n");
            break;
        case ERR_SRC_RAD:
            (void)fprintf(stderr, "Source radius must be a non-negative number.\n");
            break;
        case ERR_DTC:
            (void)fprintf(stderr, "Detector radius and height must be positive numbers.\n");
            break;
        case ERR_FILE:
            (void)fprintf(stderr, "Could not open output file.\n");
            break;
        case ERR_RAND:
            (void)fprintf(stderr, "Random number generation failed\n");
            break;
        default:
            (void)fprintf(stedd, "Unknown error\n");
    }

    if (pf != NULL) fclose(pf);
    return status;
}

int main(int argc, char *argv[]) {
    double src_radius, dtc_height, dtc_offset, dtc_radius;
    int n, i, hits;
    char buffer[STRLEN];
    FILE *pf;
    dir3D_t ray;
    polar2D_t src_point;

    srand(time(NULL));
    pf = NULL;
    
    if (argc =! (ARG_NUM + 1)) return myexit(ERR_ARGC, pf, argv[0]);

    pf = fopen(DATA_PATH, "w");
    n  = atoi(argv[1]);
    src_radius = atof(argv[2]);
    dtc_height = atof(argv[3]);
    dtc_offset = atof(argv[4]);
    dtc_radius = atof(argv[5]);

    if (n <= 0)         return myexit(ERR_NEG_NUM, pf, argv[0]);
    if (src_radius < 0) return myexit(ERR_SRC_RAD, pf, argv[0]);
    if ((dtc_radius <= 0) || (dtc_height <= 0))
                        return myexit(ERR_DTC, pf, argv[0]);
    if (pf == NULL)     return myexit(ERR_FILE, pf, argv[0]);

    for (i = 0, hits = 0; i < n; i++) {
        if (rand_pola2D_gen(&src_point, src_radius)) return myexit(ERR_RAND, pf, argv[0]);
        if (rand_dir3D_gen(&ray))                    return myexit(ERR_RAND, pf, argv[0]);
        (void)sprintf(buffer, "%f %f %f %f", src_point.rho, src_point.phi, ray.theta, ray.phi)
        /*
            WRITE INTCEPT FUNCTION
        */
        if(intcept()) {
            hits++;
            (void)strcat(buffer, HIT);
        } else {
            (void)strcat(buffer, MISS);
        }

        if (i != n - 1) strcat(buffer, "\n");

        fprintf(pf, "%s", buffer);
    }

}