# geometric-acceptance

Monte Carlo evaluation of the geometric acceptance of a flat disc detector placed above an extended, emissive flat disc. Each point on the emissive disc is modeled as an independent isotropic source.  

The user can control both the height of the detector and its horizontal offset from the vertical axis.

### User Guide

To compile the code, type the following in your Linux terminal:
```
gcc -o <path/to/executable> ext-source.c -lm
```

To run the simulation, use:
```
<path/to/executable> <number_of_points> <height> <horizontal_offset> <source_radius> <detector_radius>
```
All numbers must be positive, except for the offset, which can be negative.

The program generates an output file at `tmp/out.txt` containing the full set of generated random points.  
Each row in the file includes:

- the x and y coordinates of the source point;  
- the colatitude and longitude of the random radiation direction;  
- a `1` or `0` indicating whether the ray intersects the detector.  

### Other Files

The remaining `.c` files in the `extra` folder are drafts for simplified scenarios that do not involve a horizontal offset or an extended source. They are kept for reference and are not part of the main simulation.
