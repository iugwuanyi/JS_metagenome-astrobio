#!/bin/bash

#######################################################################################################################
# CheckM v1.0.13 was used to assess the completness and contamination of reassembled MAGS. Instructions on how to install and run
# CheckM can be found at https://github.com/Ecogenomics/CheckM
#######################################################################################################################

source ~/anaconda3/bin/activate checkm

#run checkM on reassembled active MAGs
checkm lineage_wf -x fa -t 48 JS_active_reassembledbins JS_active_binCheckm

#run checkM on reassembled relic MAGs
checkm lineage_wf -x fa -t 48 JS_relic_reassembledbins JS_relic_binCheckm

conda deactivate
