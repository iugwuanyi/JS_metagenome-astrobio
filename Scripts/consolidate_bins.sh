#!/bin/bash

#######################################################################################################################
# Bins generated using CONCOCT and metaBAT were consolidated using the bin refinement module in metaWRAP to get the  best version 
# of each bin. Only bins with a completness of >50% and contamination of <10% were selected for downstream analyses. Instructions on 
# how to install and run metaWRAP can be found at https://github.com/bxlab/metaWRAP
#######################################################################################################################

source ~/anaconda3/bin/activate metawrap-env

#consolidate bins from active metagenomes
metawrap bin_refinement -o JS_active_binRefined -t 96 -A JS_active_Binning/metabat2_bins/ -B JS_active_Binning/concoct_bins/ -c 50 -x 10

#consolidate bins from relic metagenomes
metawrap bin_refinement -o JS_relic_binRefined -t 96 -A JS_relic_Binning/metabat2_bins/ -B JS_relic_Binning/concoct_bins/ -c 50 -x 10

conda deactivate