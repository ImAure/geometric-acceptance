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

int elab_print(file_t *pf1, file_t *pf2, polar2D_t src_polar, dir3D_t ray, double height, double offset) {
    double ray_rho, equiv_y;
    point3D_t src, dtc;
    polar2D_t hist;

    if ((pf1 == NULL) || (pf2 == NULL)) return -1;

    src.x = src_polar.rho * cos(src_polar.phi);
    src.y = src_polar.rho * sin(src_polar.phi);
    src.z = 0;

    ray_rho = height / cos(ray.theta);
    /*
     * dtc.x = ray_rho * sin(ray.theta) * cos(ray.phi) + src.x;
     * dtc.y = ray_rho * sin(ray.theta) * sin(ray.phi) + src.y;
     * dtc.z = height;
     */

    dtc.x = src.x + height * tan(ray.theta) * cos(ray.phi - src_polar.phi);
    dtc.y = src.y + height * tan(ray.theta) * sin(ray.phi - src_polar.phi);
    dtc.z = height;

    equiv_y = dtc.y - offset;

    hist.rho = sqrt((dtc.x * dtc.x) + (equiv_y * equiv_y));
    hist.phi = (hist.rho == 0) ? 0 : atan2(equiv_y, dtc.x);

    (void)fprintf(pf1, "%f %f %f %f %f %f", src.x, src.y, src.z, dtc.x, dtc.y, dtc.z);
    (void)fprintf(pf2, "%f %f", hist.rho, hist.phi);
    return 0;
}

int myexit(const int status, file_t **pf, int file_num, const char *message) {
    int i;
    (void)fprintf(stderr, "An error occurred:\n");
    switch (status) {
        case ERR_ARGC:
            (void)fprintf(stderr, "Usage: %s <n> <r> <h> <d> <R> <output_file>\nWhere\n", message);
            (void)fprintf(stderr, "\tn: number of points to be generated (positive integer);\n");
            (void)fprintf(stderr, "\tr: radius of the source (cm, non negative)\n");
            (void)fprintf(stderr, "\th: height of the detector (cm, positive);\n");
            (void)fprintf(stderr, "\td: horizontal offset of the detector (cm);\n");
            (void)fprintf(stderr, "\tR: radius of the detector (positive).\n");
            (void)fprintf(stderr, "\toutput_file: the name of the file only with no extension, data will be saved in ./tmp/output_file.i.txt for i = 1,2,3.\n");
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

int main(int argc, char *argv[]) {
    double src_radius, dtc_height, dtc_offset, dtc_radius;
    double equiv_offset;
    int n, i, hits;
    char buffer[STRLEN * 2], file_name[FILE_NUM][STRLEN];
    file_t **pf;
    dir3D_t ray;
    polar2D_t src_point;

    pf = (file_t **)malloc(sizeof(file_t) * FILE_NUM);
    for (i = 0; i < FILE_NUM; ++i) (pf[i] = NULL);
    srand(time(NULL));
    
    if (argc != (ARG_NUM + 1)) return myexit(ERR_ARGC, pf, FILE_NUM, argv[0]);

    n = atoi(argv[1]);
    src_radius = atof(argv[2]);
    dtc_height = atof(argv[3]);
    dtc_offset = atof(argv[4]);
    dtc_radius = atof(argv[5]);

    for (i = 0; i < FILE_NUM; ++i) {
        (void)sprintf(file_name[i], "%s%s.%d%s", PREFIX, argv[6], i + 1, SUFFIX);
        pf[i] = fopen(file_name[i], "w");
    }

    if (n <= 0)         return myexit(ERR, pf, FILE_NUM, "Number of points must be a positive integer.");
    if (src_radius < 0) return myexit(ERR, pf, FILE_NUM, "Source radius must be a non-negative number.");
    if ((dtc_radius <= 0) || (dtc_height <= 0))
                        return myexit(ERR, pf, FILE_NUM, "Detector radius and height must be positive numbers.");
    if (pf == NULL)     return myexit(ERR, pf, FILE_NUM, "Couldn't allocate memory.");
    for (i = 0; i < FILE_NUM; ++i) if (pf[i] == NULL) return myexit(ERR_FILE, pf, FILE_NUM, file_name[i]);

    fprintf(stdout, "N: %d, src radius: %lf, dtc h: %lf, dtc offset: %lf, dtc radius: %lf\n", n, src_radius, dtc_height, dtc_offset, dtc_radius);

    for (i = 0, hits = 0; i < n; ++i) {
        if (rand_polar2D_gen(&src_point, src_radius) || rand_dir3D_gen(&ray)) return myexit(ERR, pf, FILE_NUM, "Random number generation failed.");

        if (i) (void)fprintf(pf[0], "\n");
        (void)fprintf(pf[0], "\n%f %f %f %f", src_point.rho, src_point.phi, ray.theta, ray.phi);

        equiv_offset = sqrt((src_point.rho * src_point.rho) + (dtc_offset * dtc_offset) - (2 * src_point.rho * dtc_offset * sin(src_point.phi)));
        printf("eq offset %f\n", equiv_offset);
        
        if(intcept(ray, dtc_height, equiv_offset, dtc_radius)) {
            if (hits) {
                (void)fprintf(pf[1], "\n");
                (void)fprintf(pf[2], "\n");
            }
            (void)elab_print(pf[1], pf[2], src_point, ray, dtc_height, dtc_offset);
            hits++;
        }
    }
    
    (void)fprintf(stdout, "Hits: %d/%d\nRatio: %.6f\n", hits, n, (double)hits / (n * 2));
    
    if (pf != NULL) {
        for (i = 0; i < FILE_NUM; ++i) if (pf[i] != NULL) (void)fclose(pf[i]);
        free(pf);
    }

    sprintf(buffer, "python3 newplot.py %s", file_name[1]);
    system(buffer);
    return 0;
}