#!/bin/bash

#######################################################################################################################
#
# Functions were assigned to MAGs using EnrichM v0.5.0. MAGs were annotated using the PFAM and KO database. 
# Instructions on how to install and run EnrichM can be found at https://github.com/geronimp/enrichM
#
#######################################################################################################################

source ~/anaconda3/bin/activate enrichm

#annotate dereplicated MAGs using KO database
enrichm annotate --genome_directory MAGs_drep/dereplicated_genomes/ --output MAGs_KOannotate --ko --threads 24 --suffix .fa

#annotate dereplicated MAGs using PFAM database
enrichm annotate --genome_directory MAGs_drep/dereplicated_genomes/ --output MAGs_KOannotate --pfam --threads 24 --suffix .fa

conda deactivate