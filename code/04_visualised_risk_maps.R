################################################################################
# 
# Script for the manuscript "Spatialising the ecological impacts of alien species into risk maps"  													 
#																																							 
################################################################################

# Date: 2024/08/12

# Objective: This script aim at a quick visualisation in R of the risk maps according to the aggregated impact score. The final risk maps in the main text was produced with QGIS.
   # Script to run: "03_prepa_metrics_across_sp.R"





############################### IMPORTATION DATA ############################### 

# Data importation --------------------------------------------------------
source("code/03_prepa_metrics_across_sp.R")

# Load country boundary layer
south_africa <- st_read("data/couche_shp/South_Africa_Boundary/RSA.shp") 

# Load grid layer
grid <- st_read("data/couche_shp/QDS/SA_QDS_poly.shp")




################################# PREPARATION ##################################

# Data preparation --------------------------------------------------------
names(impact_data_qds)[1] <- "Id"
names(SR)[1] <- "Id"

# Merge impact data and species richness data to the unique ID grid data
grid_impact <- merge(grid, impact_data_qds, by = "Id")
grid_SR <- merge(grid, SR, by = "Id")





#################################### Risk maps #################################

my_palette <- c("#FFF9F5","#FCBBA1", "#D0443F", "#67000D", "#290005")

# Species richness --------------------------------------------------------
	# Natural break (jenks)
SR_plot <- tm_shape(south_africa) +
	tm_borders() +
	tm_shape(grid_SR) +
	tm_fill("SR", 
					palette = my_palette, 
					style = "jenks",
					n = 5,
					title = "Species Richness") +
	tm_layout(frame = F)


# Precautionary approach --------------------------------------------------
	# Categorised and equal interval
a <- tm_shape(south_africa) +
	tm_borders() +
	tm_shape(grid_impact) +
	tm_fill("max_max", 
					palette = "Reds", 
					style = "cat",
					title = "Precautionary approach") +
	tm_layout(frame = F)


# Other risk maps ----------------------------------------------------------
	# Graduated and equal interval
create_map <- function(south_africa, grid_impact, metric, title) {
	my_palette <- c("#FFF9F5","#FCBBA1", "#D0443F", "#67000D", "#290005")
		# Create breaks based on the specified column
	breaks <- seq(min(grid_impact[[metric]], na.rm = TRUE), 
								max(grid_impact[[metric]], na.rm = TRUE), 
								length.out = 6)
	
	# Create map
	tm_shape(south_africa) +
		tm_borders() +
		tm_shape(grid_impact) +
		tm_fill(metric, 
						palette = my_palette, 
						style = "fixed",
						breaks = breaks,
						title = title) +
		tm_layout(frame = F,
							legend.text.size = 0.7, 
							legend.title.size = 1)
}

b <- create_map(south_africa, grid_impact, "max_sum", "Precautionary cumulative\napproach")
c <- create_map(south_africa, grid_impact, "max.sum_sum", "Cumulative approach")
d <- create_map(south_africa, grid_impact, "mean_sum", "Mean cumulative\napproach")
e <- create_map(south_africa, grid_impact, "mean_mean", "Mean approach")
f <- create_map(south_africa, grid_impact, "wemean_mean", "Weighted mean\napproach")

# Visualise maps in a panel graph
tmap_arrange(a, b, c, d, e, f, nrow = 3)
