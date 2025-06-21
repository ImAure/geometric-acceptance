#!/usr/bin/env python3

import sys
import os
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

NUM_IN_ROW = 8
N_R = 6
N_THETA = 10

def polar_bins(r_max, N_r, N_theta):
    r_edges = r_max * np.sqrt(np.linspace(0, 1, N_r + 1))  # bins with const area
    theta_edges = np.linspace(-np.pi, np.pi, N_theta + 1)
    return r_edges, theta_edges

def sector_vertices(r_inner, r_outer, theta_start, theta_end, z=0.0, n_points=8):
    theta = np.linspace(theta_start, theta_end, n_points)
    outer_arc = [(r_outer*np.cos(t), r_outer*np.sin(t), z) for t in theta]
    inner_arc = [(r_inner*np.cos(t), r_inner*np.sin(t), z) for t in theta[::-1]]
    return outer_arc + inner_arc

def plot_extruded_polar_histogram(rho, phi, r_max, N_r, N_theta):
    r_edges, theta_edges = polar_bins(r_max, N_r, N_theta)
    H, _, _ = np.histogram2d(rho, phi, bins=[r_edges, theta_edges])

    area = (np.pi * r_max**2) / (N_r * N_theta)
    H_density = H / area

    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')

    for i in range(N_r):
        for j in range(N_theta):
            r1, r2 = r_edges[i], r_edges[i+1]
            t1, t2 = theta_edges[j], theta_edges[j+1]
            h = H_density[i, j]
            if h == 0:
                continue

            base = sector_vertices(r1, r2, t1, t2, z=0)
            top = sector_vertices(r1, r2, t1, t2, z=h)

            verts = []
            for k in range(len(base)):
                v0 = base[k]
                v1 = base[(k+1)%len(base)]
                v2 = top[(k+1)%len(top)]
                v3 = top[k]
                verts.append([v0, v1, v2, v3])

            poly = Poly3DCollection(verts + [top],
                                    facecolor=plt.cm.inferno(h / np.max(H_density)),
                                    edgecolor='k',
                                    linewidths=0.2,
                                    alpha=0.7)
            ax.add_collection3d(poly)

    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    ax.set_zlabel("Density [1/area]")
    # ax.set_title("3D Polar Histogram")

    max_xy = r_max * 1.05
    ax.set_xlim(-max_xy, max_xy)
    ax.set_ylim(-max_xy, max_xy)
    ax.set_zlim(0, np.max(H_density) * 1.05)
    ax.set_box_aspect([1,1,0.5])
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: ./script.py <data_file> <r_detector>")
        sys.exit(1)

    file_path = sys.argv[1]
    r_detector = float(sys.argv[2])

    if not os.path.isfile(file_path):
        print(f"File {file_path} does not exist")
        sys.exit(1)

    data = np.loadtxt(file_path)

    if data.shape[1] != NUM_IN_ROW:
        raise ValueError(f"Each line must contain {NUM_IN_ROW} numbers.")

    x_start, y_start, z_start = data[:, 0], data[:, 1], data[:, 2]
    x_end,   y_end,   z_end   = data[:, 3], data[:, 4], data[:, 5]
    hist_rho, hist_phi = data[:, 6], data[:, 7]

    # === FIRST FIGURE: rays ===
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

    max_range = max(np.ptp(x_vals), np.ptp(y_vals), np.ptp(z_vals)) / 2.0
    mid_x, mid_y, mid_z = (x_vals.mean(), y_vals.mean(), z_vals.mean())

    ax.set_xlim(mid_x - max_range, mid_x + max_range)
    ax.set_ylim(mid_y - max_range, mid_y + max_range)
    ax.set_zlim(mid_z - max_range, mid_z + max_range)

    plt.tight_layout()
    plt.show()

    # === SECOND FIGURE: 3D polar histogram ===
    plot_extruded_polar_histogram(hist_rho, hist_phi, r_detector, int(len(hist_rho) ** 0.20), int(len(hist_rho) ** 0.20))
