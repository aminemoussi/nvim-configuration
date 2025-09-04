# %%
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# %%
# Your code here
r = np.arange(0, 2, 0.1)
theta = 2 * np.pi * r
theta


# %%
# Your code here
r = np.arange(0, 2, 0.1)
theta = 2 * np.pi * r
theta


# %%
import cv2

img = np.random.randint(0, 255, (256, 256, 3), dtype=np.uint8)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4))
ax1.imshow(img)
ax1.set_title("Original")
ax2.imshow(gray, cmap="gray")
ax2.set_title("Grayscale")
ax2.axis("off")
plt.tight_layout()
plt.show()

# %%
