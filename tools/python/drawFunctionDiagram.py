# coding=utf-8
import matplotlib.pyplot as plt
import numpy as np

x = np.arange(-10, 10 ,1)
y = x**2 + 2 * x + 1
plt.title("func")
plt.plot(x,y)
plt.show()