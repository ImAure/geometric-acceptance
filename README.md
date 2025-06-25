# Montecarlo method for geometric acceptance  

This program evaluates the **geometric acceptance** of a flat disc-shaped detector using a Montecarlo method. The setup consists of:

- An **emissive disc** (the source), assumed to emit particles isotropically from each point on its surface.
- A **detector disc**, positioned above the source at a configurable height and horizontal offset.

The simulation models how many particles, emitted randomly from the source, successfully reach the detector, based purely on geometry and random numbers generation.

## Features

- Fully configurable parameters:
  - Source radius
  - Detector radius
  - Detector height (distance above the source)
  - Horizontal offset of the detector
  - Number of simulated events
- Output includes full point data and detection hits for further analysis and plotting.

## Compile and run

To compile the C simulation code, use:

```bash
gcc -o path/to/executable simulation.c -lm
```

You can replace gcc with any C compiler you prefer.

To run the simulation, use:

```bash
path/to/executable number_of_points source_radius detector_x detector_y detector_z detector_radius file_name
```

Arguments:

- `number_of_points`: total number of Montecarlo samples to simulate.
- `source_radius`: radius of the emissive disc (can be 0);
- `detector_x`, `*_y`, `*_z`: Coordinates of the center of the detector. `*_z` must be positive;
- `detector_radius`: radius of the detector disc (must be positive);
- `output_file_name`: name of the file where the output will be saved.

The the output is saved in the `tmp` directory as `./tmp/file_name.i.txt`, where:

- `i=1` contains the randomly generated source points and directions;
- `i=2` contains the coordinates of starting and ending point that resulted in successful hits.

## Dependencies

- A C compiler such as `gcc`;
- Python 3 for plotting
  - Required Python packages: `matplotlib`, `numpy`, `mpl_toolkits`.

---

## Other files

The `old/` directory contains legacy `.c` files used for testing simplified scenarios (e.g. no offset or point-like sources). These are provided for reference only and are not part of the main simulation.
