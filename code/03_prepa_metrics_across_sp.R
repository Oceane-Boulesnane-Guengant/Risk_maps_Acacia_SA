################################################################################
# 
# Script for the manuscript "Spatialising the ecological impacts of alien species into risk maps"  													 
#																																							 
################################################################################

# Date: 2024/12/01

# Objective: Create a data with each aggregated impact score per grid cell to create risk maps and species richness map
	# Script to run: "02_for_prepa_across_sp.R"
	# Script used for: 
      # "04_visualised_risk_maps.R"
      # "05_graph_matric_across_species.R"





################################ IMPORTATION ###################################
source("code/02_for_prepa_across_sp.R")





########################### PREPA DATA ACROSS SPECIES ##########################

# Metrics across species 
# Species richness --------------------------------------------------------
SR <- table(select(data.distrib, id, code_name))
SR <- as.data.frame(ifelse(SR > 0, 1, 0))

SR <- as.data.frame(rowSums(SR))
SR$id <- rownames(SR)
names(SR) <- c("SR", "id")
SR <- SR[, c(2, 1)]


# Other metrics -----------------------------------------------------------

	# Merge table: data.distrib and eicat_within_sp
dist_eicat <- merge(data.distrib, eicat_within_sp, by = "code_name")

	# Calcul each approach with the function "first_agre" 
list_data <- list(SR,
									max_max <- first_agre(dist_eicat, 3, max, name_across = name_across$max),
									max_sum <- first_agre(dist_eicat, 3, sum, name_across$sum),
									mean_sum <- first_agre(dist_eicat, 4, sum, name_across$sum),
									mean_mean <- first_agre(dist_eicat, 4, mean, name_across$mean), 
									wemean_mean <- first_agre(dist_eicat, 6, mean, name_across$mean),
									max.sum_sum <- first_agre(dist_eicat, 5, sum, name_across$sum))

	# Convert list into dataframe
impact_data_qds <- reduce(list_data, inner_join, by = "id")





######################### SAVE DATA AND CLEAN SCRIPT ###########################

# Save data ---------------------------------------------------------------
# These data set are used in QGIS to create the final version of the risk maps. But could be visualised in R with script "04_visualised_risk_maps.R"
# write.csv2(SR, file = "results/241119_species_richness_R_data_SIG.csv", row.names = F)
# write.csv2(impact_data_qds, file = "results/241119_metric_QDS_R_data_SIG.csv", row.names = F)


# Clean script for "05_graph_matrics_across_species.R" -----------------------
objet <- ls()
objet_conserver <- c("impact_data_qds", "SR")
objet_supprimer <- setdiff(objet, objet_conserver)
rm(list = objet_supprimer)
rm(objet, objet_conserver, objet_supprimer)
