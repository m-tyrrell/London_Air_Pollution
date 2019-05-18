# Computes correlation matrix and plots as heatmap

# Set project directory !! INPUT REQUIRED !!
project_dir = os.path.join("/","Users","MT","Desktop","DS_Projects","DK_GST_MAY2019")
# Set data subfolder !! INPUT REQUIRED !!
subfolder = "data"

# Check all packages installed in current env before proceedings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(color_codes=True)
import time
import fnmatch
import os
import scipy
import sklearn

# Set path to file 
path = os.path.join(project_dir,subfolder,"pollution_filtered.csv")

# Import dataset
df = pd.read_csv(path)
# Remove row numbers and LSOA columns
df_red = df.iloc[:,1:26] 

##### HEATMAP
corr = np.round(df_red.corr(),2) # compute correlation matrix and round 2
mask = np.zeros_like(corr) # Set mask to show only bottom half of corr matrix
mask[np.triu_indices_from(mask)] = True
with sns.axes_style("white"):
    plt.subplots(figsize = (15, 12))
    cmap = sns.diverging_palette(220, 10, n=20)
    ax = sns.heatmap(corr, cmap=cmap,mask=mask, vmax=0.5, vmin=-0.5, square=True, annot = True, annot_kws = {'fontsize': 10}, cbar_kws={'shrink': .8})

# Output file
ax.figure.savefig(os.path.join(project_dir,"corr_heatmap.png"))