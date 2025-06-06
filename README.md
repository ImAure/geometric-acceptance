# geometric-acceptance

Monte Carlo evaluation of the geometric acceptance of a flat disc detector placed above an extended, emissive flat disc. Each point on the emissive disc is modeled as an independent isotropic source.  

The user can control both the height of the detector and its horizontal offset from the vertical axis.

## user guide

To compile the code, type the following in your Linux terminal:

```bash
gcc -o path/to/executable simulation.c -lm
```

To run the simulation, use:

```bash
path/to/executable number_of_points source_radius detector_height detector_horizontal_offset detector_radius file_name
```

All numbers must be positive, except for the source radius, which can be 0, and the offset, which can also be negative.

The program generates an output file at `./tmp/file_name.i.txt` containing the full set of generated random points, along with data for the successful hits used for plotting and data analysis.  

---

## other files

The remaining `.c` files in the `old` folder are drafts for simplified scenarios that do not involve a horizontal offset or an extended source. They are kept for reference and are not part of the main simulation.
