import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # Necessario anche se non usato direttamente

if __name__ == "__main__":
    # Percorso del file (modifica questo con il tuo path)
    file_path = "hits-cart-out.txt"

    data = np.loadtxt(file_path)

    # Controllo colonne
    if data.shape[1] != 6:
        raise ValueError("Ogni riga deve contenere esattamente sei numeri.")

    # Estrai coordinate
    x_start, y_start, z_start = data[:, 0], data[:, 1], data[:, 2]
    x_end,   y_end,   z_end   = data[:, 3], data[:, 4], data[:, 5]

    # Crea figura
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')

    # Disegna i segmenti
    for xs, ys, zs, xe, ye, ze in zip(x_start, y_start, z_start, x_end, y_end, z_end):
        ax.plot([xs, xe], [ys, ye], [zs, ze], color='gray', alpha=0.1)

    # Marker per i punti iniziali (verde) e finali (rosso)
    ax.scatter(x_start, y_start, z_start, c='red', s=5, label='Inizio')
    ax.scatter(x_end, y_end, z_end, c='green', s=5, label='Fine')

    # Etichette
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.title("Segmenti 3D con punti di partenza e arrivo")
    ax.legend()

    # Imposta la stessa scala per tutti gli assi
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
