#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM 6
#define STRLEN  1024

#define FILE_PREFIX    "./tmp/"
#define FILE_RAW_NAME  "raw"
#define FILE_CART_NAME "cartesian"
#define FILE_SUFFIX    ".txt"

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

int intcept(dir3D_t ray, double height, double offset, double radius) {
    double r2, u, u2, sin_theta, cos_theta;
    
    if (height == 0) return 0;

    r2 = radius * radius;
    u = (offset / height) * sin(ray.phi);
    u2 = u * u;
    sin_theta = sin(ray.theta);
    cos_theta = cos(ray.theta);

    return ((sin_theta * sin_theta * ((height * height + offset * offset) * (1 + u2) + r2 * (1 - u2)) - r2 + 2 * u * r2 * sin_theta * cos_theta) <= 0);
}

int cartesian_print(file_t *pf, polar2D_t src_polar, dir3D_t ray, double height, double offset) {
    double ray_rho;
    point3D_t src, dtc;

    if (pf == NULL) return -1;

    src.x = src_polar.rho * cos(src_polar.phi);
    src.y = src_polar.rho * sin(src_polar.phi);
    src.z = 0;
    
    ray_rho = height / cos(ray.theta);

    dtc.x = ray_rho * sin(ray.theta) * cos(ray.phi) + src.x;
    dtc.y = ray_rho * sin(ray.theta) * sin(ray.phi) + src.y + offset;
    dtc.z = height;

    (void)fprintf(pf, "%f %f %f %f %f %f", src.x, src.y, src.z, dtc.x, dtc.y, dtc.z);
    return 0;
}

int myexit(const int status, file_t *pf1, file_t *pf2, const char *message) {
    (void)fprintf(stderr, "An error occurred:\n");
    switch (status) {
        case ERR_ARGC:
            (void)fprintf(stderr, "Usage: %s <n> <r> <h> <d> <R> <output_file>\nWhere\n", message);
            (void)fprintf(stderr, "\tn: number of points to be generated (positive integer);\n");
            (void)fprintf(stderr, "\tr: radius of the source (cm, non negative)\n");
            (void)fprintf(stderr, "\th: height of the detector (cm, positive);\n");
            (void)fprintf(stderr, "\td: horizontal offset of the detector (cm);\n");
            (void)fprintf(stderr, "\tR: radius of the detector (positive).\n");
            break;
        case ERR_FILE:
            (void)fprintf(stderr, "Could not open output file at '%s'\n", message);
            break;
        default:
            (void)fprintf(stderr, "%s\n", message);
            break;
    }

    if (pf1 != NULL) (void)fclose(pf1);
    if (pf2 != NULL) (void)fclose(pf2);
    return status;
}

int main(int argc, char *argv[]) {
    double src_radius, dtc_height, dtc_offset, dtc_radius;
    double equiv_offset;
    int n, i, hits;
    char file1[STRLEN], file2[STRLEN];
    file_t *pf1, *pf2;
    dir3D_t ray;
    polar2D_t src_point;

    srand(time(NULL));
    pf1 = NULL;
    pf2 = NULL;

    if (argc != (ARG_NUM + 1)) return myexit(ERR_ARGC, pf1, pf2, argv[0]);

    n = atoi(argv[1]);
    src_radius = atof(argv[2]);
    dtc_height = atof(argv[3]);
    dtc_offset = atof(argv[4]);
    dtc_radius = atof(argv[5]);

    (void)sprintf(file1, "%s%s-%s%s", FILE_PREFIX, FILE_RAW_NAME, argv[6], FILE_SUFFIX);
    pf1 = fopen(file1, "w");
    (void)sprintf(file2, "%s%s-%s%s", FILE_PREFIX, FILE_CART_NAME, argv[6], FILE_SUFFIX);
    pf2 = fopen(file2, "w");

    if (n <= 0)         return myexit(ERR, pf1, pf2, "Number of points must be a positive integer.");
    if (src_radius < 0) return myexit(ERR, pf1, pf2, "Source radius must be a non-negative number.");
    if ((dtc_radius <= 0) || (dtc_height <= 0))
                        return myexit(ERR, pf1, pf2, "Detector radius and height must be positive numbers.");
    if (pf1 == NULL)    return myexit(ERR_FILE, pf1, pf2, file1);
    if (pf2 == NULL)    return myexit(ERR_FILE, pf2, pf2, file2);

    for (i = 0, hits = 0; i < n; i++) {
        if (rand_polar2D_gen(&src_point, src_radius) || rand_dir3D_gen(&ray)) return myexit(ERR, pf1, pf2, "Random number generation failed.");
        (void)fprintf(pf1, "%f %f %f %f", src_point.rho, src_point.phi, ray.theta, ray.phi);

        equiv_offset = (src_point.rho * src_point.rho) + (dtc_offset * dtc_offset) - (2 * src_point.rho * dtc_offset * sin(src_point.phi));
        if(intcept(ray, dtc_height, equiv_offset, dtc_radius)) {
            if (hits) (void)fprintf(pf2, "\n");
            (void)cartesian_print(pf2, src_point, ray, dtc_height, dtc_offset);
            hits++;
        }
        if (i != n - 1) fprintf(pf1, "\n");

    }
    if (pf1) (void)fclose(pf1);
    if (pf2) (void)fclose(pf2);
    
    (void)fprintf(stdout, "Hits: %d/%d\nRatio: %.6f\n", hits, n, (double)hits / (n * 2));
    
    return 0;
}