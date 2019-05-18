# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""



import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(color_codes=True)
import time
import fnmatch
import os
import scipy
import sklearn



# Import dataset
df = pd.read_csv("/Users/MT/Desktop/pollution_filtered2.csv")

df_red = df.iloc[:,2:26] 

##### HEATMAP

corr = df_red.corr()
mask = np.zeros_like(df_red)
mask[np.triu_indices_from(mask)] = True
with sns.axes_style("white"):
    plt.subplots(figsize = (15, 12))
    cmap = sns.diverging_palette(220, 10, n=20)
    ax = sns.heatmap(corr, cmap=cmap,vmax=0.5, vmin=-0.5, square=True, annot = True, annot_kws = {'fontsize': 12}, cbar_kws={'shrink': .8})


ax.savefig("output.png")

ax = sns.heatmap(corr)


ax.figure.savefig("output.png")