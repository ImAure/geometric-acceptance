import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

file_path = 'tmp/out.txt'

data = np.loadtxt(file_path, usecols=[0, 1, 2, 3, 4], delimiter=' ')

data_red = data[data[:, 4] == 1]
srho = data_red[:, 0]
sphi = data_red[:, 1]

rtheta = data_red[:, 2]
rphi = data_red[:, 3]

sx = srho * np.cos(sphi)
sy = srho * np.sin(sphi)

rx = np.sin(rtheta) * np.cos(rphi)
ry = np.sin(rtheta) * np.sin(rphi)
rz = np.cos(rtheta)

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('black')
fig.patch.set_facecolor('black')

for i in range(len(rx)):
    ax.plot([sx[i], rx[i]], [sy[i], ry[i]], [0, rz[i]], color='red')

ax.set_xlim([-1, 1])
ax.set_ylim([-1, 1])
ax.set_zlim([0, 2])
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.show()