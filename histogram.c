#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define ARG_COUNT   4

int myexit(int status) {
    exit(status);
}

/*
 * call as:
 * main("path/to/file", double radius, int hits);
 * it will read the file, calculate the optimal bin size and generate data for a histogram to be plotted in python.
 */
int main(int argc, char *argv[]) {
    
    if (argc != ARG_COUNT) return myexit(-1);
    
    return 0;
}