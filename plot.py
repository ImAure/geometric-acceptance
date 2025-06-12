#!/usr/bin/env python3

from os.path import isfile
import sys
import os
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

ARG_NUM = 2
NUM_IN_ROW = 6

if __name__ == "__main__":
    if len(sys.argv) != (ARG_NUM + 1):
        print("Not enought arguments")
        exit(-1)
    file_path = sys.argv[1]
    if not os.path.isfile(file_path):
        print(f"File {file_path} does not exist")
        exit(-1)

    data = np.loadtxt(file_path)

    if data.shape[1] != NUM_IN_ROW:
        raise ValueError("Each line must contain {NUM_IN_ROW} numbers.")

    x_start, y_start, z_start = data[:, 0], data[:, 1], data[:, 2]
    x_end,   y_end,   z_end   = data[:, 3], data[:, 4], data[:, 5]

    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')

    for xs, ys, zs, xe, ye, ze in zip(x_start, y_start, z_start, x_end, y_end, z_end):
        ax.plot([xs, xe], [ys, ye], [zs, ze], color='gray', alpha=0.1)

    ax.scatter(x_start, y_start, z_start, c='red', s=5, label='Source')
    ax.scatter(x_end, y_end, z_end, c='green', s=5, label='Detector')

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.title("Radiation with starting and end points")
    ax.legend()

    all_points = np.concatenate([data[:, 0:3], data[:, 3:6]])
    x_vals, y_vals, z_vals = all_points[:, 0], all_points[:, 1], all_points[:, 2]

    x_range = x_vals.max() - x_vals.min()
    y_range = y_vals.max() - y_vals.min()
    z_range = z_vals.max() - z_vals.min()
    max_range = max(x_range, y_range, z_range) / 2.0

    mid_x = (x_vals.max() + x_vals.min()) * 0.5
    mid_y = (y_vals.max() + y_vals.min()) * 0.5
    mid_z = (z_vals.max() + z_vals.min()) * 0.5

    ax.set_xlim(mid_x - max_range, mid_x + max_range)
    ax.set_ylim(mid_y - max_range, mid_y + max_range)
    ax.set_zlim(mid_z - max_range, mid_z + max_range)

    plt.show()