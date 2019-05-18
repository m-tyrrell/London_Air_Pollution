# Remove recalcitrant R object
rm(titanic_train)


# Load project
library('ProjectTemplate')
setwd(file.path('Desktop','DS_Projects','DK_GST_MAY2019'))
load.project()


# Set working directory !! INPUT REQUIRED !!
wd = file.path('Desktop','DS_Projects','DK_GST_MAY2019')
# Set data subfolder name !! INPUT REQUIRED !!
subfolder = 'data'
# Set file name !! INPUT REQUIRED !!
file_name = 'Pollution Health and Sociodemographic data.csv'

# Ensure the following packages are installed !! INPUT REQUIRED !!
library(reshape2)
library(plyr)
library(tidyverse)
library(stringr)
library(lubridate)
library(ggplot2)
library(dplyr)


# Set working directory
wd = file.path('Desktop','DS_Projects','DK_GST_MAY2019')
setwd(wd)
# Set file path to csv file
path = file.path(subfolder,file_name)
# Load file
pollution = read.csv(path)



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

# Normalise and calculate euclidian distance between NOx and IMD, Household poverty and Overcrowding
pollution_dist = pollution_filtered  %>%
        select(LSOA.Code, NOx, IMD, Households.pov, Overcrowded) %>%
        mutate(sc_nox = scale(NOx), sc_imd = scale(IMD),sc_pov = scale(Households.pov), sc_crowd = scale(Overcrowded)) %>%
        mutate(dist_imd = sqrt((min(poll_ind$sc_nox) - poll_ind$sc_nox)^2 + 
                                         (min(poll_ind$sc_imd) - poll_ind$sc_imd)^2)) %>%
        mutate(dist_pov = sqrt((min(poll_ind$sc_nox) - poll_ind$sc_nox)^2 + 
                               (min(poll_ind$sc_pov) - poll_ind$sc_pov)^2)) %>%
        mutate(dist_crowd = sqrt((min(poll_ind$sc_nox) - poll_ind$sc_nox)^2 + 
                               (min(poll_ind$sc_crowd) - poll_ind$sc_crowd)^2))

# Exploratory plots
plot(y = pollution_dist$dist_imd, x = pollution_dist$sc_nox)
# Exploratory 
hist(pollution_dist$dist_imd, breaks = 50)
summary(pollution_dist$dist_imd)


# Output relevant dataframes as csv
write.csv(pollution_filtered, file = file.path("data","pollution_filtered.csv"), row.names = FALSE)
write.csv(pollution_dist, file = file.path("data","pollution_distance.csv"), row.names = FALSE)













