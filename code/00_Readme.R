################################################################################
# 
# Readme for the scripts used for "A conceptual framework for spatialising the ecological impacts of alien species into risk maps" manuscript													 
#																																							 
################################################################################





################################################################################
# Installation packages 
################################################################################

# To run the scripts, make sure you have R (version 4.3.1) and the necessary packages installed. 
install.packages(c("dplyr","stringr", "purrr", "sf", "tmap", "ggplot2", "corrplot"))





################################################################################
# Description
################################################################################

# The present digital archive is the outcome of the paper: Boulesnane-Guengant, O, Rouget, R, Becker-Scarpitta, A, Botella, C, Kumschick, S. A conceptual framework for spatialising the ecological impact of alien species, Method in Ecology and Evolution.

# This project contains several R scripts for data analysis. The scripts are organised into modules that source each other to perform different data processing and analysis steps.

# Above is a description of each document in the three files: data, code and results.




################################################################################
# Data
################################################################################

# distrib_acacia_QDS.csv
	# Raw data of Acacia occurrence from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records (https://github.com/Oceane-Boulesnane-Guengant/Risk_maps_Acacia_SA) 



# 241008_eicat_metrics_Acacia_SA.csv
	# EICAT impact data of Acacia present in South Africa have been compiled and modified from Jensan & Kumschick, and GISD (https://github.com/Oceane-Boulesnane-Guengant/Risk_maps_Acacia_SA) 



# Files "couche_shp" contain two type of shapefile, and are only used to visualise risk maps (04_visualised_risk_maps.R script)
	# South Africa Quarter Degree Share (QDS)
	# South Africa Boundary





################################################################################
# Code
################################################################################

# 01_prepa_metrics_within_sp.R --------------------------------------------
source("code/01_prepa_metrics_within_sp.R")

#### OBJECTIVE ####
# Aggregate the impact score per Acacia species (within species) according to different metrics (maximum, sum of maximum per mechanisms, the mean and the weighted mean). Rank species according to their importance of impact per metric


#### OUTCOME ####
# Two dataframe used in "code/02_for_prepa_across_sp.R"
	# eicat_within_sp: Impact score values per species according to the different aggregation approaches
	# sp_rangs: Rang of each species according to the different aggregation approaches

# Additionaly, two other data (eicat_within_sp and sp_rangs are extracted to produce Table 4 in the main text) 



# 02_for_prepa_across_sp.R ------------------------------------------------
source("code/02_for_prepa_across_sp.R")

#### OBJECTIVE ####
# Preparation of the distribution data of Acacia alien species in South Africa. Raw data of Acacia occurrence came from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records


#### OUTCOME ####
# Tree dataframe with:
	# data.distrib: QDS ID for each Acacia species
	# eicat_within_sp: Overall impact score per species according to the metric used
	# name_across: Names of the metrics (for the function)

# One function:
	# first_agre: Function to calculate the impact score across species



# 03_prepa_metrics_across_sp.R --------------------------------------------
source("code/03_prepa_metrics_across_sp.R")

#### OBJECTIVE ####
# Assign for each QDS (per grid cell) the species richness and the impact score according to the metric used. This is directly used to create risk maps and species richness maps


#### OUTCOME ####
# Two dataframe:
	# impact_data_qds: Impact values per grid cell (QDS)
	# SR: Species richness per grid cell (QDS)
# The data are extracted to create the risk maps and species richness map on QGIS



# 04_visualised_risk_maps.R ---------------------------------------------

#### OBJECTIVE ####
# Visualisation in R of the species richness maps and risk maps according to the aggregated impact score. The final risk maps in the main text was produced with QGIS (version 3.34.2)

#### OUTCOME ####
# Species richness maps and Risk maps of the six different approaches



# 05_Graph_metric_across_species.R ----------------------------------------

#### OBJECTIVE ####
# Visualisation of distribution values of each approches and calculation of the correlation between the different approaches

#### OUTCOME ####
	# Density plot for each approaches and the species richness
	# Correlation values and plot for each approaches





################################################################################
# Outcome
################################################################################
# The different data present in the outcome file provide from the different R scripts presented above:

	# max_mean_sum_per_sp.csv: 
# Impact score per species for each aggregation approaches. Have been used to produce Table 4 in the main text
# Produce in 01_prepa_metrics_within_sp.R


	# rang_sp_metrics.csv: 
# Rang of each species according to the different aggregation approaches. Have been used to produce Table 4 in the main text.
# Produce in 01_prepa_metrics_within_sp.R


	# species_richness_R_data_SIG.csv:
# Species richness of Acacia per grid cell (QDS) in South Africa. Have been used to create the risk maps and species richness map on QGIS
# Produce in 03_prepa_metrics_across_sp.R


	# metric_QDS_R_data_SIG.csv
# Impact values per grid cell (QDS) for each aggregation approaches. Have been used to create the risk maps and species richness map on QGIS (Figure 3 and 4 on the main text)
# Produce in 03_prepa_metrics_across_sp.R


	# corrplot_metrics.png
# Correlation plot of each aggregation approach. Have been used for Figure 5 in the main
# Produce in 05_Graph_metric_across_species.R
 
