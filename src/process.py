#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DataKind Datadrive MAY2019
"""

# Check all packages installed in current env before proceeding
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(color_codes=True)
import os

# Set project directory !! INPUT REQUIRED !!
project_dir = os.path.join("/","Users","MT","Desktop","DK_GST_MAY2019")




# Process dataset
#______________________________________________________________________________

# Set path to file and import datset
data = "Pollution Health and Sociodemographic data.csv"
path = os.path.join(project_dir,data)
pollution = pd.read_csv(path)

# List of interesting variables (URBAN, DIVERSITY, DEPRIVATION)
col_names_filter = ("LSOA Code","NOx","PM10","PM2.5",
        "Population aged 0-15","Population aged 65+","Population density (persons per hectare)",
        "Change in population 2001 to 2017","Christian","People with no religious belief","Muslim",
        "White ethnic groups","Black ethnic groups","Asian ethnic groups","Born in EU Accession countries",
        "Born in non-European countries","Main language is English","Economically inactive",
        "People with no qualifications","Index of Multiple Deprivation (IMD) Score",
        "Households in poverty","Net annual household income estimate after housing costs",
        "Youth unemployment (18-24 receiving JSA or Universal Credit)","Unemployment benefit (JSA and Universal Credit)",
        "Children (dependent children aged under 20) in families in receipt of IS/JSA or whose income is <60% of median income"
        )

# List of renamed variables
col_names_rename = ("LSOA.Code","NOx","PM10","PM2.5",
        "Pop.aged.0.15","Pop.aged.65.","Pop.density",
        "Change.pop","Christian","No.rel.belief","Muslim",
        "White.ethnic","Black.ethnic","Asian.ethnic","Born.in.EU.Acc",
        "Born.non.Euro","Main.lang.Eng","Econ.inactive",
        "No.qualifications","IMD",
        "Households.pov","Net.household.inc",
        "Youth.unemploy","Unemployment.benefit",
        "Children_und_20"
)

# Select relevant columns from master pollution
pollution_filtered = pollution.loc[:,col_names_filter]

# Assign renamed variable names
pollution_filtered.columns = col_names_rename

# Output to csv
pollution_filtered.to_csv(os.path.join(project_dir,"pollution_filtered.csv"))



# Compute Pollution-Deprivation Distance Index
#______________________________________________________________________________

# Select relevant columns for distance computation
pollution_dist = pollution_filtered.loc[:,["LSOA.Code", "NOx", "IMD", "Households.pov"]]

# Normalise and add derived variables for each of NOx, IMD and Pov
pollution_dist["sc_nox"] = (pollution_dist["NOx"] - pollution_dist["NOx"].mean())/pollution_dist["NOx"].std()
pollution_dist["sc_imd"] = (pollution_dist["IMD"] - pollution_dist["IMD"].mean())/pollution_dist["IMD"].std()
pollution_dist["sc_pov"] = (pollution_dist["Households.pov"] - pollution_dist["Households.pov"].mean())/pollution_dist["Households.pov"].std()

# Compute euclidian distance between NOx and IMD/Household poverty
pollution_dist["dist_imd"] = (((pollution_dist["sc_nox"].min() - pollution_dist["sc_nox"])**2 + 
              (pollution_dist["sc_imd"].min() - pollution_dist["sc_imd"])**2)**0.5)
pollution_dist["dist_pov"] = (((pollution_dist["sc_nox"].min() - pollution_dist["sc_nox"])**2 + 
              (pollution_dist["sc_pov"].min() - pollution_dist["sc_pov"])**2)**0.5)

# Standardise range for each index variable between 0 and 1
pollution_dist["dist_imd_01"] = pollution_dist["dist_imd"]/pollution_dist["dist_imd"].max()
pollution_dist["dist_pov_01"] = pollution_dist["dist_pov"]/pollution_dist["dist_pov"].max()
              
# Output to csv
pollution_filtered.to_csv(os.path.join(project_dir,"pollution_dist.csv"))



# Correlation Matrix as Heatmap
#______________________________________________________________________________

# Remove row numbers and LSOA columns
df_red = pollution_filtered.iloc[:,1:25] 

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







