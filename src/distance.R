
# Enter working directory !! INPUT REQUIRED !!
wd = file.path('Desktop','DK_GST_MAY2019')
# Enter file name !! INPUT REQUIRED !!
file_name = 'Pollution Health and Sociodemographic data.csv'

# Ensure the following packages are installed !! INPUT REQUIRED !!
library(reshape2)
library(plyr)
library(tidyverse)
library(stringr)
library(lubridate)
library(ggplot2)
library(dplyr)

# Distance Computation
#__________________________________________________________________________________________________
# Set working directory
setwd(wd)
# Load file
pollution = read.csv(file_name)

# List of interesting variables (URBAN, DIVERSITY, DEPRIVATION)
col_names_filter = c("LSOA.Code","NOx","PM10","PM2.5",
        "Population.aged.0.15","Population.aged.65.","Population.density..persons.per.hectare.",
        "Change.in.population.2001.to.2017","Christian","People.with.no.religious.belief","Muslim",
        "White.ethnic.groups","Black.ethnic.groups","Asian.ethnic.groups","Born.in.EU.Accession.countries",
        "Born.in.non.European.countries","Main.language.is.English","Economically.inactive",
        "People.with.no.qualifications","Index.of.Multiple.Deprivation..IMD..Score",
        "Households.in.poverty","Net.annual.household.income.estimate.after.housing.costs",
        "Youth.unemployment..18.24.receiving.JSA.or.Universal.Credit.","Unemployment.benefit..JSA.and.Universal.Credit.",
        "Children..dependent.children.aged.under.20..in.families.in.receipt.of.IS.JSA.or.whose.income.is..60..of.median.income"
        )

# List of renamed variables
col_names_rename = c("LSOA.Code","NOx","PM10","PM2.5",
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
pollution_filtered = pollution[,col_names_filter]
# Assign renamed variable names
names(pollution_filtered) = col_names_rename

# Normalise and 
pollution_dist = pollution_filtered  %>%
        select(LSOA.Code, NOx, IMD, Households.pov) %>%
        mutate(sc_nox = scale(NOx), sc_imd = scale(IMD), sc_pov = scale(Households.pov))

# Compute euclidian distance between NOx and IMD/Household poverty
pollution_dist = pollution_dist %>%
        mutate(dist_imd = sqrt((min(pollution_dist$sc_nox) - pollution_dist$sc_nox)^2 + 
                                       (min(pollution_dist$sc_imd) - pollution_dist$sc_imd)^2)) %>%
        mutate(dist_pov = sqrt((min(pollution_dist$sc_nox) - pollution_dist$sc_nox)^2 + 
                                       (min(pollution_dist$sc_pov) - pollution_dist$sc_pov)^2))
# Standardise range for each index variable between 0 and 1
pollution_dist = pollution_dist %>%
        mutate(dist_imd_01 = pollution_dist$dist_imd/max(pollution_dist$dist_imd)) %>%
        mutate(dist_pov_01 = pollution_dist$dist_pov/max(pollution_dist$dist_pov)) 

# Exploratory plots
plot(y = pollution_dist$dist_pov, x = pollution_dist$sc_nox)
# Exploratory 
hist(pollution_dist$dist_pov, breaks = 45)
summary(pollution_dist$dist_pov_01)


# Output relevant dataframes as csv
write.csv(pollution_filtered, file = "pollution_filtered.csv", row.names = FALSE)
write.csv(pollution_dist, file = "pollution_distance.csv", row.names = FALSE)













