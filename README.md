# Risk_maps_Acacia_SA
The present digital archive is the outcome of the paper: A conceptual framework for spatialising the ecological impact of alien species

Approaches for mapping the ecological impact of alien species are needed to integrate impact data into biodiversity conservation policies and spatial management strategies (Katsanevakis et al., 2016). However, one species often has multiple impacts through different mechanisms (Vilà et al., 2010), and need to be aggregating for assess the global impact of species at a site level. We report a standardised approach to aggregate the impact score at a species and at sites levels to synthesise the ecological impacts of different invasive alien species into risk maps. Creating risk maps employs three main steps: (1) assign each impact category a numerical value, (2) aggregate the impact score per species (at a site level), according to different metrics used in this study (maximum, sum of the maximum per mechanisms, mean and weighed mean score), and (3) aggregate the impact score across species (of co-occurring species at a site level)

The present repository contains data, outcome and R codes for running the analyses on Acacia alien species in South Africa presented in the main text, including the different step to create risk maps, the risk maps visualisation and the correlation analyses. 

The R codes are organised into 5 R scripts that source each other to perform different data processing and analysis steps.
Above is a description of each document in the three files: data, code and results.


### Data

- distrib_acacia_QDS.csv
Raw data of Acacia occurrence from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records (GITHUB/) 

- 241008_eicat_metrics_Acacia_SA.csv
EICAT impact data of Acacia present in South Africa have been compiled and modified from Jensan & Kumschick, and GISD (GITHUB) 

- Files "couche_shp" contain two type of shapefile, and are only used to visualise risk maps (04_visualised_risk_maps.R script)
South Africa Quarter Degree Share (QDS)
South Africa Boundary





### Code

- 01_prepa_metrics_within_sp.R 

#### OBJECTIVE
Aggregate the impact score per Acacia species (within species) according to different metrics (maximum, sum of maximum per mechanisms, the mean and the weighted mean). Rank species according to their importance of impact per metric


#### OUTCOME 
Two dataframe used in "code/02_for_prepa_across_sp.R"
	eicat_within_sp: Impact score values per species according to the different aggregation approaches
	sp_rangs: Rang of each species according to the different aggregation approaches

Additionaly, two other data (eicat_within_sp and sp_rangs are extracted to produce Table 4 in the main text) 

- 02_for_prepa_across_sp.R 

#### OBJECTIVE 
Preparation of the distribution data of Acacia alien species in South Africa. Raw data of Acacia occurrence came from Botella et al., 2022 (https://doi.org/10.5281/zenodo.7679106), and have been previously modified on QGIS (version 3.34.2) to include QDS information only and filter for South African records

#### OUTCOME 
Tree dataframe with:
	data.distrib: QDS ID for each Acacia species
	eicat_within_sp: Overall impact score per species according to the metric used
	name_across: Names of the metrics (for the function)

One function:
	first_agre: Function to calculate the impact score across species



- 03_prepa_metrics_across_sp.R 

#### OBJECTIVE 
Assign for each QDS (per grid cell) the species richness and the impact score according to the metric used. This is directly used to create risk maps and species richness maps


#### OUTCOME 
Two dataframe:
	impact_data_qds: Impact values per grid cell (QDS)
	SR: Species richness per grid cell (QDS)
The data are extracted to create the risk maps and species richness map on QGIS

- 04_visualised_risk_maps.R 

#### OBJECTIVE 
Visualisation in R of the species richness maps and risk maps according to the aggregated impact score. The final risk maps in the main text was produced with QGIS (version 3.34.2)

#### OUTCOME 
Species richness maps and Risk maps of the six different approaches

-  05_Graph_metric_across_species.R 

#### OBJECTIVE 
Visualisation of distribution values of each approches and calculation of the correlation between the different approaches

#### OUTCOME 
	Density plot for each approaches and the species richness
	Correlation values and plot for each approaches






### Outcome
The different data present in the outcome file provide from the different R scripts presented above:

- max_mean_sum_per_sp.csv: 
Impact score per species for each aggregation approaches. Have been used to produce Table 4 in the main text
Produce in 01_prepa_metrics_within_sp.R


- rang_sp_metrics.csv: 
Rang of each species according to the different aggregation approaches. Have been used to produce Table 4 in the main text.
Produce in 01_prepa_metrics_within_sp.R


- species_richness_R_data_SIG.csv:
Species richness of Acacia per grid cell (QDS) in South Africa. Have been used to create the risk maps and species richness map on QGIS
Produce in 03_prepa_metrics_across_sp.R


- metric_QDS_R_data_SIG.csv
Impact values per grid cell (QDS) for each aggregation approaches. Have been used to create the risk maps and species richness map on QGIS (Figure 3 and 4 on the main text)
Produce in 03_prepa_metrics_across_sp.R


- corrplot_metrics.png
Correlation plot of each aggregation approach. Have been used for Figure 5 in the main
Produce in 05_Graph_metric_across_species.R
 
