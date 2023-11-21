#######################################################################################################################
#
# Analyses of data generated after analyzing metagenome sequences from biofilm and gravel samples collected from a 
# travertine-forming spring in Svalbard in August 2011. Metagenome sequences were processed using scripts in the Scripts 
# directory. All data tables used in this script can be found in my GitHub repository in the Data_files directory. Regression 
# analysis of on-site temperature and pH measurements included in the script For questions, please contact Ifeoma R. Ugwuanyi 
# at ifeoma.r.ugwuanyi@gmail.com.
#
#######################################################################################################################

#load required libraries
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

#generate a clean taxonomy table from the output of the Kaiju taxonomy run
clean_taxatable <- function(taxa_table){
  taxa <- taxa_table %>% select(-2)
  taxa[taxa=="cannot be assigned to a (non-viral) species"] <- "Unclassified"
  taxa[taxa==""] <- "Unclassified"
  taxa[taxa=="unclassified"] <- "Unclassified" 
  taxa[taxa=="NA"] <- "Unclassified" 
  taxa <- taxa %>% group_by(Sample,Domain,Phylum,Class,Order,Family,Genus,Species) %>% summarise_if(is.numeric, sum) %>% 
    ungroup() %>% pivot_wider(names_from = Sample, values_from = Reads, values_fill = 0)
}

#calculate the relative abundance
Rel_abund <- function(x, na.rm = F){x / sum(x, na.rm = na.rm)} 

#summarize the taxonomy table (sum) at different taxonomic levels. 
summarize_taxa <- function(taxa_table, taxa_level = c("Domain", "Phylum", "Class", "Order", "Family", "Genus")){
  taxa_level <- match.arg(taxa_level)
  taxonomiclevel_relabund <- switch(taxa_level,
                                    "Domain" = taxa_table %>% group_by(Domain) %>% summarise(across(where(is.numeric), sum)) %>% ungroup(),
                                    "Phylum" = taxa_table %>% group_by(Phylum) %>% summarise(across(where(is.numeric), sum)) %>% ungroup(),
                                    "Class" = taxa_table %>% group_by(Class) %>% summarise(across(where(is.numeric), sum)) %>% ungroup(),
                                    "Order" = taxa_table %>% group_by(Order) %>% summarise(across(where(is.numeric), sum)) %>% ungroup(),
                                    "Family" = taxa_table %>% group_by(Family) %>% summarise(across(where(is.numeric), sum)) %>% ungroup(),
                                    "Genus" = taxa_table %>% group_by(Genus) %>% summarise(across(where(is.numeric), sum)) %>% ungroup())
}  

# Select the top 20 taxa based on average at the selected taxonomic level. The summarized data is pivoted longer and the resulting table 
# will be used to generate stacked bar plots in Tableau. The Rel_abund function has to be run for this function to work
top20 <- function(table){
  name <- deparse(substitute(table))
  table_agg <- table %>% filter(table[,1] != "Unclassified") %>% dplyr::mutate(Average = rowMeans(across(where(is.numeric)))) %>% arrange(desc(Average))
  table_top20 <- table_agg %>% select(-Average) %>% slice(1:20) %>% dplyr::mutate(across(where(is.numeric), Rel_abund))
}

summarize_phyla_4_plot <- function(table, top20_phyla_list){
  phylum_others <- table %>% anti_join(top20_phyla_list, by = "Phylum") %>% mutate(Phylum = "Others") %>% group_by(Phylum) %>% summarize_if(is.numeric, sum)
  phyla_list <- top20_phyla_list$Phylum
  phylum_top20 <- table %>% filter(Phylum %in% phyla_list)
  phylum_top20_others <- phylum_top20 %>% bind_rows(phylum_others)
}

for_phylaplot <- function(table, phyla){
  phylum_others <- table %>% anti_join(phyla, by = "Phylum") %>% mutate(Phylum = "Others") %>% group_by(Phylum) %>% summarize_if(is.numeric, sum)
  phyla_list <- phyla$Phylum
  phylum_top20 <- table %>% filter(Phylum %in% phyla_list)
  phylum_top20_others <- phylum_top20 %>% bind_rows(phylum_others)}


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
# 
# Import the output file generated after assigning taxonomy to metagenome sequences using kaiju v1.8.2. The imported taxonomy table is 
# prepared for downstream analyses using the clean taxonomy table function above. Low-abundance species and potential contaminants, as listed 
# below, were then filtered from the taxonomy table. Singleton and sequences in a single column were also filtered from the taxonomy table.
#
#################################################################################################################################################

#import taxonomy table generated by Kaiju
Taxonomy_table <- read_xlsx("Data_files/JS_taxonomytable.xlsx", sheet = "Sheet1")


#prepare the taxonomy table for downstream analyses using the clean_taxonomy function above, which rotates the taxonomy table, so that samples are on separate columns
#samples are renamed to reflect names used in the published paper
Taxonomy_table2 <- clean_taxatable(Taxonomy_table) %>%
  dplyr::rename(c("A-S1" = "1", "A-S2" = "2", "A-1" = "3", "A-2" = "4", "A-3" = "5", "A-4" = "6",
                  "A-5" = "7", "R-S" = "8", "R-1" = "9", "R-2" = "10", "R-3" = "11", 
                  "R-4_a" = "12", "R-4_b" = "13", "R-5" = "14"))


#filter potential contaminants and sequences unclassified at the domain level from the taxonomy table
##filter species from individual samples if the relative abundance of the species < 0.0001 (i.e., 0.001%) in that sample
Taxonomy_table_lowabundremoved <- Taxonomy_table2 %>% mutate(across(.cols = c(8:ncol(Taxonomy_table2)), .fns = ~case_when(.x/sum(.x) <0.0001 ~ 0, TRUE ~ as.numeric(.x))), 
                                                            Counts = rowSums(across(c(8:ncol(Taxonomy_table2))))) %>% filter(Counts != 0) %>% select(-Counts)

##remove sequences that are unclassified at the domain level 
Taxonomy_table_lowabundremoved_noUnclassDomain <- Taxonomy_table_lowabundremoved %>% filter(Domain != "Unclassified")

##filter genera previously identified as microbiology kit and laboratory contaminants by Sheik et al. 2018 and Weyrich et al. 2019. The list of contaminant genera 
##used is available in my Github repository in contaminant_genus.csv 
contaminant <- read.csv("Data_files/contaminant_genus.csv", header = TRUE) #import contaminant_genus.csv
cont_genus <- contaminant$Genus #change to a list
contaminant_in_taxonomytable <- Taxonomy_table_lowabundremoved_noUnclassDomain %>% filter(Genus %in% cont_genus) #identify microbiology kit and laboratory contaminant in taxonomy table
Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont <- setdiff(Taxonomy_table_lowabundremoved_noUnclassDomain, contaminant_in_taxonomytable) #remove microbiology kit and laboratory contaminant from taxonomy table

##filter species with only one sequence in each sample (Singletons) and species in only one sample
singleton_in_taxonomytable  <- Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont %>% 
  mutate(Counts = rowSums(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont[8:ncol(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont)] > 0), 
         Total= rowSums(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont[8:ncol(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont)])) %>% 
  filter(Total < 2 | Counts < 2) %>% select(-c(Total, Counts)) #identify singletons and species in only one sample present in the taxonomy table
Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont_noSingleton <- setdiff(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont, singleton_in_taxonomytable) #remove singletons and species in only one sample from taxonomy table
write.csv(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont_noSingleton, "JS_clean_taxonomytable.csv") #export clean taxonomy table


#################################################################################################################################################
# 
# The filtered taxonomy table is summarized (sum and relative abundance) at the phylum and genus levels using the summarize_taxa function above.
# The summarized table is reduced to the top 20 taxa (based on average) at the selected taxonomic level, with all other taxa at that level
# grouped into "Other" using the summarize_phyla_4_plot above. The summarized phyla table is pivoted to generate a table used to make stacked bar 
# plots in Tableau.
#
#################################################################################################################################################

#summarize phylum
phylum <- summarize_taxa(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont_noSingleton, "Phylum") #calculate the sum of phyla in each sample
top20_phylum <- top20(phylum) #generate a table containing only the top 20 phyla using the top_20 function above
phylum_summary_forplot <- summarize_phyla_4_plot(phylum, top20_phylum) %>% mutate(across(where(is.numeric), Rel_abund)) %>% 
  pivot_longer(cols = c(2:15), names_to = "Sample", values_to = "Relative abundance") #generate a table of the top 20 phyla and all other phyla are grouped into the category "Others". Table is pivoted to generate input for Tableau
write.csv(phylum_summary_forplot, "JS_phylum_summary_forplot.csv") #export file for Tableau


#summarize genus
genus <- summarize_taxa(Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont_noSingleton, "Genus")  #calculate the sum of genera in each sample
genus_relabund <- genus %>% mutate_if(is.numeric, Rel_abund) #calculate the relative abundance of genera in each sample


#################################################################################################################################################
# 
# Alpha and beta diversity. Alpha diversity was calculated using Phyloseq.  Before calculating alpha and 
# beta diversity, the taxonomy table was rarified to the minimum number of sequences in a sample. 
#
#################################################################################################################################################

#calculate alpha diversity with phyloseq. The clean taxonomy table generated after filtering contaminants and singletons is used as input here.
species <- Taxonomy_lowabundremoved_noUnclassDomain_noKitLabCont_noSingleton[,c(7:21)] #select the species and abundance columns 
species_transp <- species %>% pivot_longer(cols = -Species) %>% pivot_wider(names_from = Species) %>% dplyr::rename("Sample" = "name") #transpose table so species names are columns and samples are rows
min_n_seqs <- min(rowSums(species_transp[-1])) #calculate the number of sequences in each sample and select the minimum number of sequences
species_transp_df <- as.data.frame(species_transp) #convert the data table from a tibble to data frame 
rownames(species_transp_df) <- species_transp_df$Sample #change row names
species_transp_df <- species_transp_df[,-1] #remove first row
species_transp_df_OTU <- otu_table(species_transp_df, taxa_are_rows = FALSE) #create a phyloseq object 
species_transp_df_rar <- rarefy_even_depth(species_transp_df_OTU, sample.size = min_n_seqs, rngseed = 123) ##rarify taxonomy table
alpha_div <- estimate_richness(species_transp_df_rar, measures = c("Observed", "Shannon")) #calculate alpha diversity
alpha_div$Pielous_Evenness <- alpha_div$Shannon/log(alpha_div$Observed) #calculate Pielou's evenness
alpha_div$Location <- rep(c("Active", "Relic"), each = 7) #create a new row in the alpha diversity table that identifies the sampling location of each sample
alpha_div$Sampling_point <- rep(c("Source", "midstream", "endstream", "Relic"), times = c(2,4,1,7)) #create a new row in the alpha diversity table that identifies the sampling point in the active spring
alpha_div <- rownames_to_column(alpha_div, var = "Sample") %>% select(Sample, Location, Sampling_point, everything()) #rearrange columns
write.csv(alpha_div, "JS_alpha_diversity.csv") #export alpha diversity table



















