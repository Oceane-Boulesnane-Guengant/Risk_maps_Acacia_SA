# Risk_maps_Acacia_SA
The present digital archive is the outcome of the paper: Spatialising the ecological impacts of alien species into risk maps

Effective approaches for mapping the ecological impacts of alien species are essential for the integration of impact data into biodiversity conservation policies and spatial management strategies (Katsanevakis et al., 2016). However, one species often has multiple impacts through different mechanisms (Vilà et al., 2010), and need to be aggregating to evaluate the overall impact of species at the site level. We present a standardised approach for aggregating impact score at both species and site levels, enabling synthesise of the ecological impacts of different invasive alien species into comprehensive risk maps. The creation of these risk maps involves four main steps: (1) perform impact assessment per species; (2) combine impact categories into one score per species; (3) gather species occurrence data into standardised grid cells; and (4) combine impact scores across species per grid cell into a risk map

The present repository contains data, results and R codes necessary for conducting the analyses on Acacia species alien in South Africa, as presented in the main text. It includes detailed steps for creating risk maps, visualising those maps, and performing correlation analyses. 

The R codes are organised into five R scripts that source each other to perform different data processing and analysis steps. Below is a description of each document within the three designated folders: data, code, and results

### DATA ###

- "distrib_acacia_QDS.csv"
Raw data of Acacia occurrence is based on Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records.

- "241008_eicat_metrics_Acacia_SA.csv"
The EICAT impact data of Acacia present in South Africa was compiled and modified from Jensan & Kumschick, and Global Invasive Species Database (GISD) (http://www.issg.org/database)

- Folder *couche_shp* contains two type of shapefile, which are exclusively used for the visualisation of risk maps (refer to the  R code "04_visualised_risk_maps.R")
South Africa Quarter Degree Share (QDS)
South Africa Boundary

### CODE ###
#### 01_prepa_metrics_within_sp.R 

- __Objective__: Aggregate the impact score for each Acacia species (within species) based on different metrics (maximum, sum of maximum per mechanisms, the mean and the weighted mean). Rank species according to their importance of impact for each metric
- __Outcomes__ : Two dataframes used in "code/02_for_prepa_across_sp.R"
	- *eicat_within_sp*: Impact score values per species according to the different aggregation approaches
	- *sp_rangs*: Rank of each species according to the different aggregation approaches

Additionaly, two other data tables (*eicat_within_sp* and *sp_rangs*) were extracted to produce Table 4 presented in the main text) 

#### 02_for_prepa_across_sp.R 

- __Objective__: Preparation of the distribution data of Acacia alien species in South Africa. Raw data of Acacia occurrence is based on Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records.

- __Outcomes__ : 
	- Tree dataframes with:  
		- *data.distrib*: QDS ID for each Acacia species
		- *eicat_within_sp*: Overall impact score for each species according to the metric used
		- *name_across*: Names of the metrics (used in the following function)
	- One function:  
		- *first_agre*: Function to calculate the impact score across species

#### 03_prepa_metrics_across_sp.R 

- __Objective__: Assign for each QDS (i.e. a spatial grid cell) the species richness and the impact score according to the metric used. These are directly used to create risk maps and species richness map

- __Outcomes__ :
	- Two dataframes:
		- *impact_data_qds*: Impact values per QDS
		- *SR*: Species richness per QDS

The data are extracted to create the risk maps and species richness map on QGIS

#### 04_visualised_risk_maps.R 

- __Objective__: Visualisation in R of the species richness map and risk maps according to the different metrics used to aggregated the impact score within and across species. The final risk maps presented in the main text was generated using QGIS (version 3.34.2)

- __Outcome__ : Species richness map and risk maps of the six different combinaisons (metric x aggregation approaches)

####  05_Graph_metric_across_species.R 

- __Objective__: Visualisation of distribution values of each approch and calculation of the correlation between the different approaches

- __Outcomes__ :
	- Density plot for each approach and the species richness
	- Correlation values and plot for each approach

### RESULTS ###
The different results produced in the 5 codes are presented above:

- "max_mean_sum_per_sp.csv":  

The impact score for each species, calculated using the six different aggregation approaches, were used to generate Table 4 presented in the main text. These scores were produced using the script titled "01_prepa_metrics_within_sp.R"

- "rank_sp_metrics.csv": 

Ranking of each species based on the different metrics used to aggregate impact score within species. The ranking results were to produce Table 4 presented in the main text. These ranking were produce using the script titled "01_prepa_metrics_within_sp.R"

- "species_richness_R_data_SIG.csv":

Values of species richness of Acacia per grid cell (QDS) in South Africa. These species richness values were used to create species richness map on QGIS (Figure 3 presented in the main text) and were produced using the script titled "03_prepa_metrics_across_sp.R"

- "metric_QDS_R_data_SIG.csv"

Impact values per grid cell (QDS) for each aggregation approaches. These impact values were used to create the risk maps on QGIS (Figure 4 presented in the main text) and were produced using the script titled "03_prepa_metrics_across_sp.R"


- corrplot_metrics.png

Correlation plot of each aggregation approach. These plots were used to produce Figure 5 presented in the main and were produced using the script titled "05_Graph_metric_across_species.R"
 
