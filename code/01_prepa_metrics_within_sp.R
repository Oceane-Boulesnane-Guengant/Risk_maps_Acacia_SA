################################################################################
# 
# Script for the manuscript "Spatialising the ecological impacts of alien species 
# into risk maps"  													 
#																																							 
################################################################################

# Date: 2024/12/01

# Objective: Calculate the maximum, the sum of maximum per mechanism, the mean and the weighted mean impact score per Acacia species





################################ LIBRARY #######################################
# install.packages(c("dplyr","stringr", "purrr", "sf", "tmap", "ggplot2", "corrplot"))

# Call the library need for all scripts
library(dplyr)
library(stringr)
library(purrr)
library(sf)
library(tmap)
library(ggplot2)
library(corrplot)





################################# IMPORTATION ##################################
# EICAT data of Acacia species in South Africa
eicat_metrics <- read.csv2("data/241119_eicat_metrics_Acacia_SA.csv", stringsAsFactors = FALSE)

# The data "241008_eicat_metrics_Acacia_SA.csv"  have 4 columns named: 
	# 1. code_name: code name of alien species (characters)
	# 2. eicat: numerical eicat values (from impact categories)
	# 3. mechanisms: impact mechanisms, with the number (e.g. (1) Competition) (characters)
	# 4. proba: numerical values of the probability that the impact is in the right category (for the weighted mean)

# Convert data type if needed
# eicat_metrics$proba <- as.numeric(eicat_metrics$proba)
# str(eicat_metrics)




############################ IMPACT WITHIN SPECIES #############################


# Confidence score --------------------------------------------------------

## Assign the confidence score for each record (base on IUCN, 2020)
# Create new column with the probabilities that the score is in the right impact categories (IUCN 2020)

add_proba <- function(data) {
	conf <- data %>% select(eicat, confidence)
	
	ID_unique <- as.data.frame(paste(conf$eicat, conf$confidence, sep = "_"))
	names(ID_unique) <- "ID"
	
	ID_unique <- unique(ID_unique)
	
	ID_unique$proba <- ifelse(ID_unique$ID == "0_high", 0.1, ID_unique$ID)
	ID_unique$proba <- ifelse(ID_unique$proba == "0_low", 1.03, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "0_medium", 0.27, ID_unique$proba)
	
	ID_unique$proba <- ifelse(ID_unique$proba == "1_high", 1.01, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "1_low", 1.46, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "1_medium", 1.05, ID_unique$proba)
	
	ID_unique$proba <- ifelse(ID_unique$proba == "2_high", 2, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "2_low", 2, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "2_medium", 2, ID_unique$proba)
	
	ID_unique$proba <- ifelse(ID_unique$proba == "3_high", 2.99, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "3_low", 2.54, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "3_medium", 2.95, ID_unique$proba)
	
	ID_unique$proba <- ifelse(ID_unique$proba == "4_high", 3.9, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "4_low", 2.97, ID_unique$proba)
	ID_unique$proba <- ifelse(ID_unique$proba == "4_medium", 3.73, ID_unique$proba)
	
	data$ID <- paste(data$eicat, data$confidence, sep = "_")
	data <- merge(data, ID_unique, by = "ID")
	
	# Delete the ID_unique column
	data <- data[, -1]
	data
}
eicat_metrics <- add_proba(eicat_metrics)

eicat_metrics$proba <- as.numeric(eicat_metrics$proba)
eicat_metrics <- select(eicat_metrics, - confidence)

# Metrics -----------------------------------------------------------------

## Maximum eicat score per species 
max <- eicat_metrics %>% 
	group_by(code_name) %>%
	summarise(max_eicat = max(eicat))

## Sum of the maximum score per mechanism and species 
sum_max_mecha <- function(data){
	# Separate into several columns when one line have several impact mechanisms
	data_sp_meca <- as.data.frame(str_split(data$mechanism, "; ", simplify = T))
	data_sp_meca$code_name <- data$code_name
	data_sp_meca$eicat <- data$eicat
	
	# Select only the number of the mechanism ((1) for competition)
	data_sp_meca$V1 <- str_extract(data_sp_meca$V1, pattern = "\\d+")
	data_sp_meca$V2 <- str_extract(data_sp_meca$V2, pattern = "\\d+")
	data_sp_meca$V3 <- str_extract(data_sp_meca$V3, pattern = "\\d+")
	data_sp_meca$V4 <- str_extract(data_sp_meca$V4, pattern = "\\d+")
	
	# Create a new data to have only 3 columns (species, eicat, mechanisms)
	V1 <- select(data_sp_meca, code_name, eicat, V1)
	names(V1)[3] <- "mechanism"
	V2 <- select(data_sp_meca, code_name, eicat, V2)
	names(V2)[3] <- "mechanism"
	V3 <-  select(data_sp_meca, code_name, eicat, V3)
	names(V3)[3] <- "mechanism"
	V4 <- select(data_sp_meca, code_name, eicat, V4)
	names(V4)[3] <- "mechanism"
	
	data_sp_meca2 <- rbind(V1, V2, V3, V4)

	# Delete NA
	data_sp_meca2 <- na.omit(data_sp_meca2)
	
	# Calculate the maximum per mechanisms and species
	max_meca_sp <- as.data.frame(tapply(data_sp_meca2$eicat, 
																			list(data_sp_meca2$code_name, data_sp_meca2$mechanism), 
																			max))
	max_meca_sp$code_name <- row.names(max_meca_sp)
	
	# Calculate the sum of maximum per mechanisms per species
	max_sum <- max_meca_sp
	max_sum$max.sum_eicat <- rowSums(max_sum[1:6], na.rm = T)
	max_sum <- select(max_sum, code_name, max.sum_eicat)
	
	max_sum
}
max_sum <- sum_max_mecha(eicat_metrics)

## Mean eicat score per species
mean <- eicat_metrics %>%
	group_by(code_name) %>%
	summarise(mean_eicat = mean(eicat))

## Mean eicat score per species weighted per confidence levels from EICAT (IUCN 2020)
w.mean.eicat <- eicat_metrics %>%
	group_by(code_name) %>%
	summarise(wemean_eicat = mean(proba))

# Merging		
eicat_within_sp <- merge(max, mean, by = "code_name")
eicat_within_sp <- merge(eicat_within_sp, max_sum, by = "code_name")
eicat_within_sp <- merge(eicat_within_sp, w.mean.eicat, by = "code_name")
rm(max, mean, max_sum, w.mean.eicat)

# Ranking species according to their overall impact score per metrics
sp_ranks <- eicat_within_sp %>%
	mutate(Rank_Max = dense_rank(-max_eicat),
				 Rank_Mean = dense_rank(-mean_eicat),
				 Rank_W.mean.eicat = dense_rank(-wemean_eicat),
				 Rank_Sum_Max = dense_rank(-max.sum_eicat)) %>%
	select(code_name, Rank_Max, Rank_Mean, Rank_W.mean.eicat, Rank_Sum_Max) 





######################### SAVE DATA AND CLEAN SCRIPT ###########################

# Save data ---------------------------------------------------------------
# Data extraction to produce Table 4 in the main text
# write.csv2(eicat_within_sp, file = "results/241119_max_mean_sum_per_sp.csv", row.names = F)
# write.csv2(sp_ranks, file = "results/241119_rank_sp_metrics.csv", row.names = F)


# Clean script for "02_for_prepa_across_sp.R" --------------------------------
rm(eicat_metrics, sum_max_mecha)
