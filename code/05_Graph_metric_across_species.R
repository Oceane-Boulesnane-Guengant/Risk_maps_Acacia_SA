################################################################################
# 
# Script for the manuscript "Spatialising the ecological impacts of alien species into risk maps"  													 
#																																							 
################################################################################

# Date: 2024/05/30

# Objective: calculate the correlation between the different approaches and the plot the distribution values for each approach.
	# Script to run: "03_prepa_metrics_across_sp.R"





################################# IMPORTATION ##################################
source("code/03_prepa_metrics_across_sp.R")





################################ DENSITY PLOTS #################################

# Species richness --------------------------------------------------------
ggplot(data = SR, aes(x = SR)) +
	geom_density(fill="#69b3a2", color="#e9ecef", alpha = 0.8) +
	scale_x_continuous(breaks = seq(0, 24, by = 2))


# Approaches --------------------------------------------------------------
density_plot <- function(data, metric, title) {
	
	p <- ggplot(data = data, aes(x = .data[[metric]])) +
		geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) + 
		ggtitle(title) + 
		xlab("Impact values")
	p
}

density_plot(impact_data_qds, "max_max", "Precautionary approach")
density_plot(impact_data_qds, "max_sum", "Precautionary cumulative approach")
density_plot(impact_data_qds, "max.sum_sum", "Cumulative approach")
density_plot(impact_data_qds, "mean_sum", "Mean cumulative approach")
density_plot(impact_data_qds, "mean_mean", "Mean approach")
density_plot(impact_data_qds, "wemean_mean", "Weighted mean approach")





######################### COMPARAISON BTW APPROACHES ###########################

# Correlation matrix ------------------------------------------------------
	# rename the columns for the correlation matrix figure
names(impact_data_qds) <- c("id", "a.SR", "d.P", "b.P.C", "c.M.C", "e.M", "f.W.M", "C")

	# Correlation matrix
data_matrix <- cor(impact_data_qds[, 2:8])

# Visualisation -----------------------------------------------------------
corrplot(data_matrix,
				 method = "circle", 
				 type = "upper",
				 order = "alphabet",
				 tl.col = "black",
				 tl.srt = 45,
				 col = c("#FFFFE5","#CC4C02" , "#FEC44F", "#FFF7BC", "#FEE391", "#FE9929", "#EC7014", "#8C2D04"),
				 col.lim = c(-0.25, 1),
				 diag = F,
				 number.cex = 0.8, 
				 addCoef.col = "black")





################################# SAVE DATA ####################################

# Image extraction to produce Figure 4 in the main text
saved_plot <- recordPlot()
png("results/241119_corrplot_metrics.png", width = 684, height = 392)
replayPlot(saved_plot)
dev.off()

