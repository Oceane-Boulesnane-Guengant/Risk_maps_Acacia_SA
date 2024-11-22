################################################################################
# 
# Script for the manuscript "Spatialising the ecological impacts of alien species into risk maps"  													 
#																																							 
################################################################################

# Date : 2024/05/30

# Objective: Preparation of the distribution data of Acacia. Raw data of Acacia occurrence came from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS to include QDS information only and filter for South African records
	# Script needed to run: "01_prepa_metrics_within_sp.R"
	# Script used for: 
       # "03_prepa_metric_across_sp.R"





################################ IMPORTATION ###################################

# Data --------------------------------------------------------------------

## Impact score summarised per species
source("code/01_prepa_metrics_within_sp.R")

## Distribution data of the species
data.distrib <- read.csv("data/distrib_acacia_QDS.csv", header = T, sep = ",", dec = ".")
names(data.distrib) <- str_to_lower(names(data.distrib))


# Function to calculate the impact score across species -------------------
first_agre <- function(data, column, metric, name_across2){ 
	# Function for calculating impact scores by grid cell (id)
		# data: data with, for each id, the species with the within sp
		# column = column number used for within species 
	          	# 3 = max_eicat; 4 = mean_eicat; 5 = max.sum_eicat, 6 = w.e_eicat
		# metric: metrics to use (max/sum/mean) to aggregate impact across sp
		# nom_across2: name of the new column (for data across sp) 
			# Example: nom_across$name_column = name_across$max so that it then becomes max_max
	name <- names(data)[column] # Selection of column names with the 3 metrics within species
	data_qds <- data %>% 
		group_by(id) %>%
		summarise_at(name, metric)
	
	# Name of the nex columns (across sp)
	name_within <- sub("_.*", "", name) 
	name2 <- paste(name_within, name_across2, sep = "_")
	names(data_qds)[2] <- name2
	
	# Print QDS data
	data_qds
}

name_across <- data.frame(max = "max", sum = "sum", mean = "mean",  max_sum = "max_sum", wemean = "wemean")





################################# PREPARATION ##################################

# Column "code_name" ------------------------------------------------------
# First three letters of FAMILY and first four letters of SPECIES
data.distrib <- mutate(data.distrib, code_name = paste(substr(species, 1,1),
																										 substr(species, 8, 12), sep = "."))
data.distrib$code_name <- str_to_lower(data.distrib$code_name)





################################### DATA QDS ###################################
# Preparation of a data with the list of species present in each grid cell

# Select columns from the distribution data -------------------------------
data.distrib <- data.distrib %>% select(code_name, id)

# Delete the 3 rows with NA
data.distrib	<- na.omit(data.distrib)

# Select only data with QDS values
data.distrib <- as.data.frame(table(data.distrib))
data.distrib <- data.distrib[data.distrib$Freq > 0, ]
data.distrib <- data.distrib %>% select(code_name, id)





################################# CLEAN SCRIPT #################################

# Clean script for "03_prepa_metrics_across_sp.R" -------------------------
rm(sp_ranks)


