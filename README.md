# Risk_maps_Acacia_SA
The present digital archive is the outcome of the paper: A conceptual framework for spatialising the ecological impact of alien species

Approaches for mapping the ecological impact of alien species are needed to integrate impact data into biodiversity conservation policies and spatial management strategies (Katsanevakis et al., 2016). However, one species often has multiple impacts through different mechanisms (Vilà et al., 2010), and need to be aggregating for assess the global impact of species at a site level. We report a standardised approach to aggregate the impact score at a species and at sites levels to synthesise the ecological impacts of different invasive alien species into risk maps. Creating risk maps employs three main steps: (1) assign each impact category a numerical value, (2) aggregate the impact score per species (at the site level), according to different metrics used in this study (maximum, sum of the maximum per mechanisms, mean and weighed mean score), and (3) aggregate the impact score across species (of co-occurring species at a site level)

The present repository contains data, outcome and R codes for running the analyses on Acacia alien species in South Africa presented in the main text, including the different step to create risk maps, the risk maps visualisation and the correlation analyses. 

The R codes are organised into 5 R scripts that source each other to perform different data processing and analysis steps.
Above is a description of each document in the three folders: data, code and results.


### DATA ###

- distrib_acacia_QDS.csv
Raw data of Acacia occurrence from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records 

- 241008_eicat_metrics_Acacia_SA.csv
EICAT impact data of Acacia present in South Africa have been compiled and modified from Jensan & Kumschick, and GISD 

- Folder couche_shp contains two type of shapefile, and are only used to visualise risk maps (sf. code 04_visualised_risk_maps.R)
South Africa Quarter Degree Share (QDS)
South Africa Boundary

### CODE ###
#### 01_prepa_metrics_within_sp.R 

- __Objective__: Aggregate the impact score per Acacia species (within species) according to different metrics (maximum, sum of maximum per mechanisms, the mean and the weighted mean). Rank species according to their importance of impact per metric
- __Outcomes__ : Two dataframes used in "code/02_for_prepa_across_sp.R"
	- *eicat_within_sp*: Impact score values per species according to the different aggregation approaches
	- *sp_rangs*: Rank of each species according to the different aggregation approaches

Additionaly, two other data tables (*eicat_within_sp* and *sp_rangs* are extracted to produce Table 4 in the main text) 

#### 02_for_prepa_across_sp.R 

- __Objective__: Preparation of the distribution data of Acacia alien species in South Africa. Raw data of Acacia occurrence is based on Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records.

- __Outcomes__ : 
	- Tree dataframes with:  
		- *data.distrib*: QDS ID for each Acacia species
		- *eicat_within_sp*: Overall impact score per species according to the metric used
		- *name_across*: Names of the metrics (used in the following function)
	- One function:  
		- *first_agre*: Function to calculate the impact score across species

#### 03_prepa_metrics_across_sp.R 

- __Objective__: Assign for each QDS (i.e. a spatial grid cell) the species richness and the impact score according to the metric used. This is directly used to create risk maps and species richness map

- __Outcomes__ :
	- Two dataframes:
		- *impact_data_qds*: Impact values per QDS
		- *SR*: Species richness per QDS

The data are extracted to create the risk maps and species richness map on QGIS

#### 04_visualised_risk_maps.R 

- __Objective__: Visualisation in R of the species richness maps and risk maps according to the aggregated impact score. The final risk maps in the main text was produced with QGIS (version 3.34.2)

- __Outcome__ : Species richness map and risk maps of the six different combinaisons (metric x aggregation approaches)

####  05_Graph_metric_across_species.R 

- __Objective__: Visualisation of distribution values of each approch and calculation of the correlation between the different approaches

- __Outcomes__ :
	- Density plot for each approach and the species richness
	- Correlation values and plot for each approach

### RESULTS ###
The different results produced in the 5 codes are presented above:

- max_mean_sum_per_sp.csv:  

The impact score for each species, calculated using the different aggregation methods, were used to generate Table 4 in the main text. These scores were produce using the script *01_prepa_metrics_within_sp.R*

- rang_sp_metrics.csv: 

Rang of each species according to the different aggregation approaches. Have been used to produce Table 4 in the main text  
Produce in *01_prepa_metrics_within_sp.R*

- species_richness_R_data_SIG.csv:

Species richness of Acacia per grid cell (QDS) in South Africa. Have been used to create the risk maps and species richness map on QGIS  
Produce in *03_prepa_metrics_across_sp.R*

- metric_QDS_R_data_SIG.csv

Impact values per grid cell (QDS) for each aggregation approaches. Have been used to create the risk maps and species richness map on QGIS (Figure 3 and 4 on the main text)  
Produce in *03_prepa_metrics_across_sp.R*


- corrplot_metrics.png

Correlation plot of each aggregation approach. Have been used for Figure 5 in the main

Produce in 05_Graph_metric_across_species.R
 
