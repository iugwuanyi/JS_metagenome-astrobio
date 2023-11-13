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
# Below are a few functions used for data manipulation and analyses 
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

