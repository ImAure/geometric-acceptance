#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define ARG_NUM  7
#define FILE_NUM 2
#define STRLEN   4096
#define PREFIX  "./tmp/"
#define SUFFIX  ".txt"
#define PY_CALL "python3 newplot.py"


#define ERR_ARGC -1
#define ERR_FILE -2
#define ERR       1

typedef struct _cart2D {
    double x;
    double y;
} cart2D_t;

typedef struct _polar2D {
    double rho;
    double phi;
} polar2D_t;

typedef struct _cart3D {
    double x;
    double y;
    double z;
} cart3D_t;

typedef struct _polar3D {
    double rho;
    double theta;
    double phi;
} polar3D_t;

typedef struct _point2D {
    cart2D_t  cart;
    polar2D_t polar;
} point2D_t;

typedef struct _point3D {
    cart3D_t  cart;
    polar3D_t polar;
} point3D_t;

typedef struct _disc2D {
    point2D_t center;
    double    radius;
} disc2D_t;

typedef struct _disc3D {
    point3D_t center;
    double    radius;
} disc3D_t;

typedef FILE file_t;

int polar_to_cart2D(polar2D_t *src, cart2D_t *dst) {
    if (src == NULL || dst == NULL) return -1;
    dst->x = src->rho * cos(src->phi);
    dst->y = src->rho * sin(src->phi);
    return 0;
}

int cart_to_polar2D(cart3D_t *src, polar2D_t *dst) {
    if (src == NULL || dst == NULL) return -1;
    dst->rho = sqrt(src->x * src->x + src->y * src->y);
    dst->phi = atan2(src->y, src->x);
    return 0;
}

int polar_to_cart3D(polar3D_t *src, cart3D_t *dst) {
    if (src == NULL || dst == NULL) return -1;
    dst->x = src->rho * sin(src->theta) * cos(src->phi);
    dst->y = src->rho * sin(src->theta) * sin(src->phi);
    dst->z = src->rho * cos(src->theta);
    return 0; 
}

int rand_polar2D(polar2D_t *ptr, double radius) {
    if (ptr == NULL) return -1;
    ptr->rho = (radius < 0) ? 1 : (sqrt((double)rand() / RAND_MAX) * radius);
    ptr->phi = (radius == 0) ? 0 : ((double)rand() / RAND_MAX) * (2 * M_PI);
    return 0;
}

int rand_polar3D(polar3D_t *ptr, double radius) {
    if (ptr == NULL) return -1;
    ptr->rho = (radius < 0) ? 1 : (cbrt((double)rand() / RAND_MAX) * radius);
    if (radius == 0) {
        ptr->theta = 0;
        ptr->phi   = 0;
    } else {
        ptr->theta = acos(1 - 2 * ((double)rand() / RAND_MAX));
        ptr->phi   = ((double)rand() / RAND_MAX) * (2 * M_PI);
    }
    return 0;
}

int intercept(file_t *pf, point2D_t src, polar3D_t ray, disc3D_t detector3D, int *hits) {
    point3D_t hit_point3D;
    point2D_t dtc_point2D;
    point3D_t dtc_point3D_hist;
    point2D_t dtc_point2D_hist;
    double u;

    u = detector3D.center.cart.z * tan(ray.theta);
    if (cart_to_polar2D(&detector3D.center.cart, &dtc_point2D.polar)) return -1;

    if ((u * u + dtc_point2D.polar.rho * dtc_point2D.polar.rho - 2 * u * dtc_point2D.polar.rho * cos(ray.phi - dtc_point2D.polar.phi)) <= detector3D.radius * detector3D.radius) {
        hit_point3D.cart.x = src.cart.x + u * cos(ray.phi);
        hit_point3D.cart.y = src.cart.y + u * sin(ray.phi);
        hit_point3D.cart.z = detector3D.center.cart.z;
        
        dtc_point3D_hist.cart.x = hit_point3D.cart.x - (detector3D.center.cart.x + src.cart.x);
        dtc_point3D_hist.cart.y = hit_point3D.cart.y - (detector3D.center.cart.y + src.cart.y);

        cart_to_polar2D(&dtc_point3D_hist.cart, &dtc_point2D_hist.polar);
        
        fprintf(pf, (*hits) ? ("\n%f %f %f %f %f %f %f %f") : ("%f %f %f %f %f %f %f %f"), src.cart.x, src.cart.y, 0.0, hit_point3D.cart.x, hit_point3D.cart.y, hit_point3D.cart.z, dtc_point2D_hist.polar.rho, dtc_point2D_hist.polar.phi);
        ++(*hits);
    }
    return 0;
}

int my_exit(const int status, file_t **pf, int file_num, const char *message) {
    int i;
    (void)fprintf(stderr, "An error occurred:\n");
    switch (status) {
        case ERR_ARGC:
            (void)fprintf(stderr, "Usage: %s <n> <src r> <dtc x> <dtc y> <dtc z> <dtc r> <output_file>\n", message);
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
    int i, n, hits;
    char buffer[STRLEN * 2], file_name[FILE_NUM][STRLEN];
    file_t **file;
    disc3D_t source3D, detector3D_abs, detector3D_rel;
    polar3D_t ray;
    point2D_t src_point2D;

    file = (file_t **)calloc(FILE_NUM, sizeof(file_t *));

    srand(time(NULL));

    if (argc != (ARG_NUM + 1)) return my_exit(ERR_ARGC, file, FILE_NUM, argv[0]);

    n = atoi(argv[1]);

    source3D.center.cart.x = 0;
    source3D.center.cart.y = 0;
    source3D.center.cart.z = 0;
    source3D.radius = atof(argv[2]);

    detector3D_abs.center.cart.x = atof(argv[3]);
    detector3D_abs.center.cart.y = atof(argv[4]);
    detector3D_abs.center.cart.z = atof(argv[5]);
    detector3D_abs.radius = atof(argv[6]);

    for (i = 0; i < FILE_NUM; ++i) {
        (void)sprintf(file_name[i], "%s%s.%d%s", PREFIX, argv[7], i + 1, SUFFIX);
        file[i] = fopen(file_name[i], "w");
    }

    if (n <= 0)                     return my_exit(ERR, file, FILE_NUM, "Number of points must be a positive integer.");
    if (source3D.radius < 0)        return my_exit(ERR, file, FILE_NUM, "Source radius must be a non-negative number.");
    if (detector3D_abs.radius <= 0) return my_exit(ERR, file, FILE_NUM, "Detector radius must be a positive number.");
    if (file == NULL)               return my_exit(ERR, file, FILE_NUM, "Couldn't allocate memory.");
    for (i = 0; i < FILE_NUM; ++i)  if (file[i] == NULL) return my_exit(ERR_FILE, file, FILE_NUM, file_name[i]);

    detector3D_rel.center.cart.z = detector3D_abs.center.cart.z;
    detector3D_rel.radius =  detector3D_abs.radius;

    for (i = 0, hits = 0; i < n; ++i) {
        if (rand_polar2D(&src_point2D.polar,  source3D.radius)) return my_exit(ERR, file, FILE_NUM, "Random 2D point generation failed.");
        if (rand_polar3D(&ray,               -1))               return my_exit(ERR, file, FILE_NUM, "Random direction generation failed.");

        if (polar_to_cart2D(&src_point2D.polar, &src_point2D.cart)) return my_exit(ERR, file, FILE_NUM, "Invalid pointer in conversion");

        detector3D_rel.center.cart.x = detector3D_abs.center.cart.x - src_point2D.cart.x;
        detector3D_rel.center.cart.y = detector3D_abs.center.cart.y - src_point2D.cart.y;
        
        (void)fprintf(file[0], (i) ? ("\n%f %f %f %f") : ("%f %f %f %f"), src_point2D.polar.rho, src_point2D.polar.phi, ray.theta, ray.phi);

        intercept(file[1], src_point2D, ray, detector3D_rel, &hits);
    }

    (void)fprintf(stdout, "Hits: %d/%d\nRatio: %.6f\n", hits, n, (double)hits / (n * 2));
    if (file != NULL) {
        for (i = 0; i < FILE_NUM; ++i) if (file[i] != NULL) (void)fclose(file[i]);
        (void)free(file);
    }

    (void)sprintf(buffer, "%s %s %f", PY_CALL, file_name[1], detector3D_abs.radius);
    (void)system(buffer);
    return 0;
}