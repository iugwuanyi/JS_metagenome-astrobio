#######################################################################################################################
#
# Analyses of data generated after analyzing metagenome sequences from biofilm and gravel samples collected from a 
# travertine-forming spring in Svalbard in August 2011. Metagenome sequences were processed using scripts in the Scripts 
# directory. All data tables used in this script can be found in my GitHub repository in the Data_files directory.
# For questions, please contact Ifeoma R. Ugwuanyi at ifeoma.r.ugwuanyi@gmail.com.
#
#######################################################################################################################


##load required libraries
library(dplyr) # Tidying data
library(tidyverse) # Set of packages for data manipulation and visualization
library(tidyr) # Data manipulation
library(readxl) # Importing excel files
library(phyloseq) # Analysis of microbiome data
library(vegan) # Community ecology analysis
library(EcolUtils) # Community ecology analysis
library(stringr) # String manipulation
library(ggplot2) # Data Visualization

####################################################################################################################### 
#
# Below are a few functions used in this script for data manipulation and analyses 
#
#######################################################################################################################

#generate clean taxonomy table from kaiju output
clean_taxatable <- function(taxa_table){
  taxa <- taxa_table %>% select(-2)
  taxa[taxa=="cannot be assigned to a (non-viral) species"] <- "Unclassified"
  taxa[taxa==""] <- "Unclassified"
  taxa[taxa=="unclassified"] <- "Unclassified" 
  taxa[taxa=="NA"] <- "Unclassified" 
  taxa <- taxa %>% group_by(Sample,Domain,Phylum,Class,Order,Family,Genus,Species) %>% summarise_if(is.numeric, sum) %>% 
    ungroup() %>% pivot_wider(names_from = Sample, values_from = Reads, values_fill = 0)
}



#################################################################################################################################################
#
# Correlation between temperature and pH measurements taken from sampling points along Jotun active spring (in situ) at three different years
#
#################################################################################################################################################

#temperature and pH measurements taken from the spring at 3 different years (2007, 2009, and 2011) 
Jotun_temp <- c(21.00, 18.90, 12.80, 22.10, 22.00, 21.40, 21.50, 21.90, 22.10, 22.00, 20.80)
Jotun_pH <- c(6.69, 6.79, 7.86, 6.55, 6.58, 6.25, 6.54, 6.60, 6.59, 6.63, 6.86)

#linear regression analysis between temperature and pH
temp_ph.lm <- lm(Jotun_temp ~ Jotun_pH)
summary(temp_ph.lm)



#################################################################################################################################################
# Import the output file generated after assigning taxonomy to metagenome sequences using kaiju v1.8.2. The imported taxonomy table is 
# prepared for downstream analyses using the clean taxonomy table function above. Low abundance species and potential contaminants as listed 
# below were then filtered from taxonomy table. Singleton and sequences in a single column were also filtered from the taxonomy table.
#################################################################################################################################################

# Import taxonomy table and prepare table for downstream analyses
Taxonomy_table <- read_xlsx("Data_files/JS_taxonomytable.xlsx", sheet = "Sheet1")
Taxonomy_table <- clean_taxatable(Taxonomy_table) %>%
  dplyr::rename(c("A-S1" = "1", "A-S2" = "2", "A-1" = "3", "A-2" = "4", "A-3" = "5", "A-4" = "6",
                  "A-5" = "7", "R-S" = "8", "R-1" = "9", "R-2" = "10", "R-3" = "11", 
                  "R-4_a" = "12", "R-4_b" = "13", "R-5" = "14"))

