#!/bin/bash

#######################################################################################################################
#
# Taxonomy was assigned to bins based on the Genome Taxonomy Database (GTDB) using GTDB-TK v1.7.0 which classifies 
# MAGs based on placement in a reference tree inferred utilizing a set of 120 bacterial and 122 archaeal marker genes. 
# Instructions on how to install and run GTDB-TK can be found at https://ecogenomics.github.io/GTDBTk/
#
#######################################################################################################################

source ~/anaconda3/bin/activate gtdbtk

#call genes and markers for dereplicated MAGs
gtdbtk identify --genome_dir MAGs_drep/dereplicated_genomes/ --out_dir MAG_GTDBTKidentify --cpus 12 -x fa

#align identified genes and markers
gtdbtk align --identify_dir MAG_GTDBTKidentify --out_dir MAG_GTDBTKalign --cpus 12

#classify MAGs
gtdbtk classify --genome_dir MAGs_drep/dereplicated_genomes/ --align_dir MAG_GTDBTKalign --out_dir MAG_GTDBTKclassify --cpus 12 -x fa

conda deactivate