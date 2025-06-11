#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM  6
#define FILE_NUM 3
#define STRLEN   4096
#define PREFIX  "./tmp/"
#define SUFFIX  ".txt"

#define ERR_ARGC -1
#define ERR_FILE -2
#define ERR       1

typedef struct _dir3D {
    double theta;
    double phi;
} dir3D_t;

typedef struct _polar2D {
    double rho;
    double phi;
} polar2D_t;

typedef struct _point3D {
    double x;
    double y;
    double z;
} point3D_t;

typedef FILE file_t;

int myexit(const int status, file_t **pf, int file_num, const char *message) {
    int i;
    (void)fprintf(stderr, "An error occurred:\n");
    switch (status) {
        case ERR_ARGC:
            (void)fprintf(stderr, "Usage: %s <n> <src r> <dtc x> <dtc y> <dtc z> <dtc r> <output_file>\nWhere\n", message);
            /*
            (void)fprintf(stderr, "\tn: number of points to be generated (positive integer);\n");
            (void)fprintf(stderr, "\tr: radius of the source (cm, non negative)\n");
            (void)fprintf(stderr, "\th: height of the detector (cm, positive);\n");
            (void)fprintf(stderr, "\td: horizontal offset of the detector (cm);\n");
            (void)fprintf(stderr, "\tR: radius of the detector (positive).\n");
            (void)fprintf(stderr, "\toutput_file: the name of the file only with no extension, data will be saved in ./tmp/output_file.i.txt for i = 1,2,3.\n");*/
            break;
        case ERR_FILE:
            (void)fprintf(stderr, "Could not open output file at '%s'\n", message);
            break;
        default:
            (void)fprintf(stderr, "%s\n", message);
            break;
    }

    if (pf != NULL) {
        for (i = 0; i < file_num; ++i) if (pf[i] != NULL) (void)fclose(pf[i]);
        free(pf);
    }
    return status;
}

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
        ptr->phi = 0;
    } else {
        ptr->rho = sqrt(((double)rand() / RAND_MAX) * (max_rho * max_rho));
        ptr->phi = ((double)rand() / RAND_MAX) * (2 * M_PI);
    }
    return 0;
}

intcept(dir3D_t ray, polar2D_t src_polar, point3D_t dtc_cart) {
    double dx, dy, d, d2, u, u2;
    point3D_t src_cart;

    src_cart.x = src_polar.rho * cos(src_polar.phi);
    src_cart.y = src_polar.rho * sin(src_polar.phi);
    src_cart.z = 0;

    if (dtc_cart.z == 0) return 0;

    dx = dtc_cart.x - src_cart.x;
    dy = dtc_cart.y - src_cart.x;

    d2 = dx * dx + dy * dy;

    u = dtc_cart.z * ray.theta;

    return (d2 + (u * u) - (2 * sqrt(d2) * u * cos(src_polar.phi - atan2(dtc_cart.y, dtc_cart.x))));
}


int main(int argc, char *argv[]) {
    double src_radius, dtc_radius;
    int n, i, hits;
    char buffer[STRLEN * 2], file_name[FILE_NUM][STRLEN];
    file_t **pf;
    dir3D_t ray;
    polar2D_t src_polar, dtc_polar;
    point3D_t src_cart, dtc_cart;

    pf = (file_t **)malloc(sizeof(file_t) * FILE_NUM);
    for (i = 0; i < FILE_NUM; ++i) (pf[i] = NULL);
    srand(time(NULL));
    
    if (argc != (ARG_NUM + 1)) return myexit(ERR_ARGC, pf, FILE_NUM, argv[0]);

    n          = atoi(argv[1]);
    src_radius = atof(argv[2]);
    dtc_cart.x = atof(argv[3]);
    dtc_cart.y = atof(argv[4]);
    dtc_cart.z = atof(argv[5]);
    dtc_radius = atof(argv[6]);

    for (i = 0; i < FILE_NUM; ++i) {
        (void)sprintf(file_name[i], "%s%s.%d%s", PREFIX, argv[6], i + 1, SUFFIX);
        pf[i] = fopen(file_name[i], "w");
    }

    if (n <= 0) return myexit(ERR, pf, FILE_NUM, "Number of points must be a positive integer.");
    if (src_radius < 0) return myexit(ERR, pf, FILE_NUM, "Source radius must be a non-negative number.");
    if (dtc_radius <=0 0) return myexit(ERR, pf, FILE_NUM, "Detector radius must be a positive number.");
    if (pf == NULL)     return myexit(ERR, pf, FILE_NUM, "Couldn't allocate memory.");
    for (i = 0; i < FILE_NUM; ++i) if (pf[i] == NULL) return myexit(ERR_FILE, pf, FILE_NUM, file_name[i]);

    for (i = 0, hits = 0; i < n; ++i) {
        if (rand_polar2D_gen(&src_point, src_radius) || rand_dir3D_gen(&ray)) return myexit(ERR, pf, FILE_NUM, "Random number generation failed.");

        if (i) (void)fprintf(pf[0], "\n");
        (void)fprintf(pf[0], "\n%f %f %f %f", src_point.rho, src_point.phi, ray.theta, ray.phi);

        if (intcept(ray, src_polar, dtc_cart)) {
            if (hits) {
                (void)fprintf(pf[1], "\n");
                (void)fprintf(pf[2], "\n");
            }
            (void)elab_print(pf[1], pf[2], src_point, ray, dtc_height, dtc_offset);
            ++hits;
        }
    }


    return 0;
}

int elab_print(file_t *pf1, file_t *pf2, polar2D_t src_polar, dir3D_t ray, point3D_t dtc_cart, double dtc_polar_phi) {
    double u;
    point3D_t hit_cart;

    u = dtc_cart.z * tan(ray.theta);

    hit_cart.x = src_polar.rho * cos(src_polar.phi) + u * cos(src_polar.phi - dtc_polar_phi);
    hit_cart.y = src_polar.rho * sin(src_polar.phi) + u * sin(src_polar.phi - dtc_polar_phi);
    hit_cart.z = dtc_cart.z;

    
}
